#include "Core/Version.h"
#include "Core/Project/Project.h"
#include "Core/LogicModel/Layer.h"
#include "Core/Project/ProjectImporter.h"
#include "Core/Project/ProjectExporter.h"
#include "Core/Matching/TemplateMatching.h"
#include "Core/LogicModel/LogicModelHelper.h"
#include <iostream>

using namespace degate;

int main(int argc, char* argv[])
{
    if(argc < 3) {
        std::cout << "USAGE: " << argv[0] << " name dir" << std::endl;
        return 1;
    }
    std::string project_name(argv[1]);
    std::string project_directory(argv[2]);

    ProjectImporter importer;
    Project_shptr project = importer.import_all(project_directory);

    // Do the thing
    TemplateMatching_shptr matching = nullptr;
    // Can be also TemplateMatchingInRows / TemplateMatchingInCols
    matching = std::make_shared<TemplateMatchingNormal>();

    // Param calc
    std::list<GateTemplate_shptr> gate_templates;
    GateLibrary_shptr gate_library = project->get_logic_model()->get_gate_library();
    for (auto& gate : *gate_library)
        gate_templates.push_back(gate.second);

    ScalingManager_shptr scaling_manager = project->get_logic_model()->get_current_layer()->get_scaling_manager();
    if (scaling_manager == nullptr)
        return 4;
    const auto steps = scaling_manager->get_zoom_steps();
    std::vector<unsigned int> valid_steps;
    for (auto& step : steps)
    {
        bool is_ok = true;
        if (step != 1)
        {
            for (auto& gate : gate_templates)
            {
                if (std::floor(static_cast<double>(gate->get_width()) / static_cast<double>(step)) < 10 ||
                    std::floor(static_cast<double>(gate->get_height()) / static_cast<double>(step) < 10))
                {
                    is_ok = false;
                }
            }
        }

        if (is_ok)
            valid_steps.push_back((unsigned int)step);
    }

    // Param
    std::list<degate::Gate::ORIENTATION> orientations_list;
    orientations_list.push_back(Gate::ORIENTATION_NORMAL);
    orientations_list.push_back(Gate::ORIENTATION_FLIPPED_UP_DOWN);
    orientations_list.push_back(Gate::ORIENTATION_FLIPPED_LEFT_RIGHT);
    orientations_list.push_back(Gate::ORIENTATION_FLIPPED_BOTH);
    
    matching->set_threshold_hc(0.4);
    matching->set_threshold_detection(0.70);
    matching->set_max_step_size(std::max((length_t)1, project->get_lambda() >> 1u));
    matching->set_scaling_factor(valid_steps[0]);
        
    matching->set_templates(gate_templates);
    matching->set_layers(project->get_logic_model()->get_current_layer(),
                            get_first_logic_layer(project->get_logic_model()));
    matching->set_orientations(orientations_list);

    matching->init(project->get_bounding_box(), project);
    matching->run();

    ProjectExporter exporter;
    exporter.export_all(project->get_project_directory(), project);

    return 0;
}

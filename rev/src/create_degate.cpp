#include "Core/Version.h"
#include "Core/Project/Project.h"
#include "Core/LogicModel/Layer.h"
#include "Core/Project/ProjectExporter.h"
#include "Core/LogicModel/LogicModelHelper.h"
#include <iostream>
#include <stdlib.h>

using namespace degate;

int main(int argc, char* argv[])
{
    if(argc < 6) {
        std::cout << "USAGE: " << argv[0] << " name dir layer_metal.tiff layer_full.tiff layer_full.tiff [lambda]" << std::endl;
        return 1;
    }
    std::string project_name(argv[1]);
    std::string project_directory(argv[2]);

    QImageReader reader(argv[3]);
    QSize size = reader.size();
    if (!size.isValid()) {
        std::cerr << "Cannot read size of " << argv[3] << std::endl;
        return 2;
    }

    ProjectType project_type = ProjectType::Normal;
    int width = size.width(), height = size.height();
    Project project(width,
                    height,
                    project_directory,
                    project_type,
                    3);
    project.set_name(project_name);
    if(argc >= 7) {
        length_t lambda = (length_t)atoi(argv[6]);
        project.set_lambda(lambda);
    }
    LogicModel::layer_collection layer_collection;

    for(int i = 0; i < 3; i++) {
        Layer layer(
            BoundingBox(project.get_logic_model()->get_width(), 
                        project.get_logic_model()->get_height()), 
                        project.get_project_type());
        layer.set_layer_id(project.get_logic_model()->get_new_layer_id());
        layer.set_enabled(true);
        switch(i) {
            case 0: layer.set_layer_type(layer.LAYER_TYPE::METAL); break;
            case 1: layer.set_layer_type(layer.LAYER_TYPE::LOGIC); break;
            case 2: layer.set_layer_type(layer.LAYER_TYPE::TRANSISTOR); break;
            default: layer.set_layer_type(layer.LAYER_TYPE::UNDEFINED); break;
        }

        layer.set_layer_pos(i);

        Layer_shptr layer_ptr = std::make_shared<Layer>(layer);
        std::string background(argv[3+i]);
        load_new_background_image(layer_ptr, project.get_project_directory(), background);

        layer_collection.push_back(layer_ptr);
    }
    project.get_logic_model()->set_layers(layer_collection);

    ProjectExporter exporter;
    Project_shptr prjptr = std::make_shared<Project>(project);
    exporter.export_all(project.get_project_directory(), prjptr);

    return 0;
}

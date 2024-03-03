// This only defines the cells, but the function is bogus
// It seems lctime does not give me a verilog.

module INVD1(i, z);
  input i;
  output z;
  assign z = !i;
endmodule

module ND2D1(a1, a2, zn);
  input a1, a2;
  output zn;
  assign zn = !(a1 && a2);
endmodule

module NR2D1(a1, a2, zn);
  input a1, a2;
  output zn;
  assign zn = !(a1 || a2);
endmodule

module TIEH(z);
  output z;
  assign z = 1'b1:
endmodule

module TIEL(zn);
  output zn;
  assign zn = 1'b0:
endmodule

module BUFFD1(i, z);
  input i;
  output z;
  assign z = i;
endmodule

module ND3D1(a1, a2, a3, zn);
  input a1, a2, a3;
  output zn;
  assign zn = !(a1 && a2 && a3);
endmodule

module ND4D1(a1, a2, a3, a4, zn);
  input a1, a2, a3, a4;
  output zn;
  assign zn = !(a1 && a2 && a3 && a4);
endmodule

module NR3D1(a1, a2, a3, zn);
  input a1, a2, a3;
  output zn;
  assign zn = !(a1 || a2 || a3);
endmodule

module NR4D1(a1, a2, a3, a4, zn);
  input a1, a2, a3, a4;
  output zn;
  assign zn = !(a1 || a2 || a3 || a4);
endmodule

module XOR2D1(a1, a2, z);
  input a1, a2;
  output z;
  assign z = (a1 && !a2) || (!a1 && a2);
endmodule

module XNR2D1(a1, a2, zn);
  input a1, a2;
  output zn;
  assign zn = (a1 && a2) || (!a1 && !a2);
endmodule

module AN2D1(a1, a2, z);
  input a1, a2;
  output z;
  assign z = (a1 && a2);
endmodule

module OR2D1(a1, a2, z);
  input a1, a2;
  output z;
  assign z = (a1 || a2);
endmodule

module OA21D1(a1, a2, b, z);
  input a1, a2, b;
  output z;
  assign z = (a1&b) | (a2&b);
endmodule

module AO21D1(a1, a2, b, z);
  input a1, a2, b;
  output z;
  assign z = (a1&a2) | (b);
endmodule

module OAI21D1(a1, a2, b, z);
  input a1, a2, b;
  output z;
  assign z = (!a1&!a2) | (!b);
endmodule

module AOI21D1(a1, a2, b, z);
  input a1, a2, b;
  output z;
  assign z = (!a1&!b) | (!a2&!b);
endmodule

module MUX2D1(i0, i1, s, z);
  input i1, i2, s;
  output z;
  assign z = (i0&!s) | (i1&s);
endmodule

module LNQD1(d, en, q);
  input d, en;
  output q;
  reg q = 1'b0;
  always @(en) if(en) q <= d;
endmodule

module DFQD1(d, cp, q);
  input d, cp;
  output q;
  reg q = 1'b0;
  always @(posedge cp) q <= d;
endmodule

module DFCNQD1(d, cp, cdn, q);
  input d, cp, cdn;
  output q;
  reg q = 1'b0;
  always @(posedge cp and negedge cdn) if(!cdn) q <= 1'b0 else q <= d;
endmodule

// ** Additional from here

module ND2D1_1(a1, a2, zn);
  input a1, a2;
  output zn;
  assign zn = !(a1 && a2);
endmodule

module NR2D1_1(a1, a2, zn);
  input a1, a2;
  output zn;
  assign zn = !(a1 || a2);
endmodule

module BUFFD1_1(i, z);
  input i;
  output z;
  assign z = i;
endmodule

module ND3D1_1(a1, a2, a3, zn);
  input a1, a2, a3;
  output zn;
  assign zn = !(a1 && a2 && a3);
endmodule

module ND4D1_1(a1, a2, a3, a4, zn);
  input a1, a2, a3, a4;
  output zn;
  assign zn = !(a1 && a2 && a3 && a4);
endmodule

module NR3D1_1(a1, a2, a3, zn);
  input a1, a2, a3;
  output zn;
  assign zn = !(a1 || a2 || a3);
endmodule

module NR4D1_1(a1, a2, a3, a4, zn);
  input a1, a2, a3, a4;
  output zn;
  assign zn = !(a1 || a2 || a3 || a4);
endmodule

module XOR2D1_1(a1, a2, z);
  input a1, a2;
  output z;
  assign z = (a1 && !a2) || (!a1 && a2);
endmodule

module XNR2D1_1(a1, a2, zn);
  input a1, a2;
  output zn;
  assign zn = (a1 && a2) || (!a1 && !a2);
endmodule

module AN2D1_1(a1, a2, z);
  input a1, a2;
  output z;
  assign z = (a1 && a2);
endmodule

module OR2D1_1(a1, a2, z);
  input a1, a2;
  output z;
  assign z = (a1 || a2);
endmodule

module OA21D1_1(a1, a2, b, z);
  input a1, a2, b;
  output z;
  assign z = (a1&b) | (a2&b);
endmodule

module AO21D1_1(a1, a2, b, z);
  input a1, a2, b;
  output z;
  assign z = (a1&a2) | (b);
endmodule

module OAI21D1_1(a1, a2, b, z);
  input a1, a2, b;
  output z;
  assign z = (!a1&!a2) | (!b);
endmodule

module AOI21D1_1(a1, a2, b, z);
  input a1, a2, b;
  output z;
  assign z = (!a1&!b) | (!a2&!b);
endmodule

module MUX2D1_1(i0, i1, s, z);
  input i1, i2, s;
  output z;
  assign z = (i0&!s) | (i1&s);
endmodule

module LNQD1_1(d, en, q);
  input d, en;
  output q;
  reg q = 1'b0;
  always @(en) if(en) q <= d;
endmodule

module DFQD1_1(d, cp, q);
  input d, cp;
  output q;
  reg q = 1'b0;
  always @(posedge cp) q <= d;
endmodule

module DFCNQD1_1(d, cp, cdn, q);
  input d, cp, cdn;
  output q;
  reg q = 1'b0;
  always @(posedge cp and negedge cdn) if(!cdn) q <= 1'b0 else q <= d;
endmodule

module ND2D1_2(a1, a2, zn);
  input a1, a2;
  output zn;
  assign zn = !(a1 && a2);
endmodule

module NR2D1_2(a1, a2, zn);
  input a1, a2;
  output zn;
  assign zn = !(a1 || a2);
endmodule

module ND3D1_2(a1, a2, a3, zn);
  input a1, a2, a3;
  output zn;
  assign zn = !(a1 && a2 && a3);
endmodule

module ND4D1_2(a1, a2, a3, a4, zn);
  input a1, a2, a3, a4;
  output zn;
  assign zn = !(a1 && a2 && a3 && a4);
endmodule

module NR3D1_2(a1, a2, a3, zn);
  input a1, a2, a3;
  output zn;
  assign zn = !(a1 || a2 || a3);
endmodule

module NR4D1_2(a1, a2, a3, a4, zn);
  input a1, a2, a3, a4;
  output zn;
  assign zn = !(a1 || a2 || a3 || a4);
endmodule

module XOR2D1_2(a1, a2, z);
  input a1, a2;
  output z;
  assign z = (a1 && !a2) || (!a1 && a2);
endmodule

module XNR2D1_2(a1, a2, zn);
  input a1, a2;
  output zn;
  assign zn = (a1 && a2) || (!a1 && !a2);
endmodule

module AN2D1_2(a1, a2, z);
  input a1, a2;
  output z;
  assign z = (a1 && a2);
endmodule

module OR2D1_2(a1, a2, z);
  input a1, a2;
  output z;
  assign z = (a1 || a2);
endmodule

module OA21D1_2(a1, a2, b, z);
  input a1, a2, b;
  output z;
  assign z = (a1&b) | (a2&b);
endmodule

module AO21D1_2(a1, a2, b, z);
  input a1, a2, b;
  output z;
  assign z = (a1&a2) | (b);
endmodule

module OAI21D1_2(a1, a2, b, z);
  input a1, a2, b;
  output z;
  assign z = (!a1&!a2) | (!b);
endmodule

module AOI21D1_2(a1, a2, b, z);
  input a1, a2, b;
  output z;
  assign z = (!a1&!b) | (!a2&!b);
endmodule

module MUX2D1_2(i0, i1, s, z);
  input i1, i2, s;
  output z;
  assign z = (i0&!s) | (i1&s);
endmodule

module LNQD1_2(d, en, q);
  input d, en;
  output q;
  reg q = 1'b0;
  always @(en) if(en) q <= d;
endmodule

module DFQD1_2(d, cp, q);
  input d, cp;
  output q;
  reg q = 1'b0;
  always @(posedge cp) q <= d;
endmodule

module DFCNQD1_2(d, cp, cdn, q);
  input d, cp, cdn;
  output q;
  reg q = 1'b0;
  always @(posedge cp and negedge cdn) if(!cdn) q <= 1'b0 else q <= d;
endmodule

module ND2D1_3(a1, a2, zn);
  input a1, a2;
  output zn;
  assign zn = !(a1 && a2);
endmodule

module NR2D1_3(a1, a2, zn);
  input a1, a2;
  output zn;
  assign zn = !(a1 || a2);
endmodule

module ND3D1_3(a1, a2, a3, zn);
  input a1, a2, a3;
  output zn;
  assign zn = !(a1 && a2 && a3);
endmodule

module ND4D1_3(a1, a2, a3, a4, zn);
  input a1, a2, a3, a4;
  output zn;
  assign zn = !(a1 && a2 && a3 && a4);
endmodule

module NR3D1_3(a1, a2, a3, zn);
  input a1, a2, a3;
  output zn;
  assign zn = !(a1 || a2 || a3);
endmodule

module NR4D1_3(a1, a2, a3, a4, zn);
  input a1, a2, a3, a4;
  output zn;
  assign zn = !(a1 || a2 || a3 || a4);
endmodule

module XOR2D1_3(a1, a2, z);
  input a1, a2;
  output z;
  assign z = (a1 && !a2) || (!a1 && a2);
endmodule

module XNR2D1_3(a1, a2, zn);
  input a1, a2;
  output zn;
  assign zn = (a1 && a2) || (!a1 && !a2);
endmodule

module AN2D1_3(a1, a2, z);
  input a1, a2;
  output z;
  assign z = (a1 && a2);
endmodule

module OR2D1_3(a1, a2, z);
  input a1, a2;
  output z;
  assign z = (a1 || a2);
endmodule

module OA21D1_3(a1, a2, b, z);
  input a1, a2, b;
  output z;
  assign z = (a1&b) | (a2&b);
endmodule

module AO21D1_3(a1, a2, b, z);
  input a1, a2, b;
  output z;
  assign z = (a1&a2) | (b);
endmodule

module OAI21D1_3(a1, a2, b, z);
  input a1, a2, b;
  output z;
  assign z = (!a1&!a2) | (!b);
endmodule

module AOI21D1_3(a1, a2, b, z);
  input a1, a2, b;
  output z;
  assign z = (!a1&!b) | (!a2&!b);
endmodule

module MUX2D1_3(i0, i1, s, z);
  input i1, i2, s;
  output z;
  assign z = (i0&!s) | (i1&s);
endmodule

module LNQD1_3(d, en, q);
  input d, en;
  output q;
  reg q = 1'b0;
  always @(en) if(en) q <= d;
endmodule

module DFQD1_3(d, cp, q);
  input d, cp;
  output q;
  reg q = 1'b0;
  always @(posedge cp) q <= d;
endmodule

module DFCNQD1_3(d, cp, cdn, q);
  input d, cp, cdn;
  output q;
  reg q = 1'b0;
  always @(posedge cp and negedge cdn) if(!cdn) q <= 1'b0 else q <= d;
endmodule



//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : graemej
// Creation Date   : 2017 Sep 03
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : alu_in interface agent
// Unit            : Interface HDL Typedefs
// File            : alu_in_typedefs_hdl.svh
//----------------------------------------------------------------------
//     
// DESCRIPTION: 
// This file contains defines and typedefs to be compiled for use in
// the simulation running on the emulator when using Veloce.
//
// ****************************************************************************
// ****************************************************************************
//----------------------------------------------------------------------
//
                                                                               

typedef enum bit[2:0] {no_op = 3'b000, add_op = 3'b001, and_op = 3'b010, xor_op = 3'b011, mul_op = 3'b100, rst_op = 3'b111} alu_in_op_t;


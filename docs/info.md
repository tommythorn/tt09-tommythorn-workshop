<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

A Sigma-Delta PDM emits on `uo_out[1]`.  A UART listens for bytes (8N1 115,200 assuming clk is 50 MHz)
and shifts that into the lower 8-bit of a 16-bit level.

## How to test

TBD: It is possible to drive bitbanged serial output from the onboard RP2020.  The PDM output can be observed
on a scope or filtered to get a smooth analogue signal.  It makes for a lousy DAC as at best you can update it
115,200/10/2 = 5760 times a second and the updates aren't atomic (thus will have artifacts).  It's just a
proof-of-concept.

## External hardware

Scope and/or analogue filter.

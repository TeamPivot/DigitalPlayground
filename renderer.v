module renderer (
	input clk,
	input [9:0] hcount,
	input [9:0] vcount,
	input [2:0] in_pixel [7:0],
	output hsync,
	output vsync,
	output reg [2:0] out_pixel [7:0]
	);

	parameter hpx = 640,
			  hfp = 16,
			  hsync_len = 96,
			  hbp = 48,
			  vpx = 480,
			  vfp = 11,
			  vsync_len = 2,
			  vbp = 32,
			  vsync_beg = vpx + vfp,
			  vsync_end = vsync_beg + vsync_len,
			  hsync_beg = hpx + hfp,
			  hsync_end = hsync_beg + hsync_len,
			  hblanking = hfp + hsync_len + hbp,
			  vblanking = vfp + vsync_len + vbp,
			  hlen = hpx + hblanking,
			  vlen = vpx + vblanking,
			  hlimit = hlen - 1,
			  vlimit = vlen - 1;

	always @ (posedge clk) begin
		if (hcount == hlimit) begin
			hcount = 0;
			vcount = vcount == vlimit ? 0 : vcount + 1;
		end
		else
			hcount = hcount + 1;

		hsync = !(hcount >= hsync_beg && hcount < hsync_end);
		vsync = !(vcount >= vsync_beg && vcount < vsync_end); 

		out_pixel = hcount < hpx && vcount < vpx ? in_pixel : 0;
	end

endmodule

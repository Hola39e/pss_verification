class ahb_driver extends uvm_driver #(ahb_seq_item, ahb_seq_item);

    `uvm_component_utils(ahb_driver)

    virtual ahb_if AHB;

    // --------------------
    // data members
    // --------------------

    extern function new (string name = "ahb_driver", uvm_component parent = null);
    extern task run_phase(uvm_phase phase);

endclass

function ahb_driver::new (string name = "ahb_driver", uvm_component parent = null);
    super.new(name, parent);
endfunction

task ahb_driver::run_phase(uvm_phase phase);
    ahb_seq_item req;
    logic [31:0]  HADDR;
    logic [1:0] HTRANS;
    logic HWRITE;
    logic [2:0] HSIZE;
    logic [2:0] HBURST;
    logic [3:0] HPROT;
    logic [31:0]  HWDATA;
    logic [31:0]  HRDATA;
    logic [1:0] HRESP;
    logic HREADY;
    logic HSEL;

    AHB.HADDR <= 0;
    AHB.HTRANS <= 0;
    AHB.HWRITE <= 0;
    AHB.HSIZE <= 2;
    AHB.HBURST <= AHB_SINGLE;
    AHB.HPROT <= 0;
    AHB.HWDATA <= 0;
    AHB.HSEL <= 0;

    @(posedge AHB.HRESETn);
    forever begin
        seq_item_port.get_next_item(req);
        @(posedge AHB.HCLK);
        AHB.HADDR <= req.HADDR;
        AHB.HWRITE <= req.HWRITE;
        AHB.HTRANS <= AHB_NON_SEQ;
        @(posedge AHB.HCLK iff(AHB.HREADY == 1));
        AHB.HADDR <= 0;
        AHB.HWRITE <= 0;
        AHB.HTRANS <= AHB_IDLE;
        if(req.HWRITE == AHB_WRITE) begin
            AHB.HWDATA <= req.DATA;
        end
        @(posedge AHB.HCLK iff(AHB.HREADY == 1));
        if(req.HWRITE == AHB_READ) begin
            req.DATA = AHB.HRDATA;
        end
        seq_item_port.item_done();
    end
endtask
class ahb_monitor extends uvm_component;

    `uvm_component_utils(ahb_monitor)

    virtual ahb_if AHB;

    uvm_analysis_port #(ahb_seq_item) ap;

    extern function new(string name = "ahb_monitor", uvm_component parent = null);
    extern function void build_phase(uvm_phase phase);
    extern task run_phase (uvm_phase phase);
    extern function void report_phase(uvm_phase phase);
endclass

function ahb_monitor::new(string name = "ahb_monitor", uvm_component parent = null);
    super.new(name, parent);
endfunction

function ahb_monitor::build_phase(uvm_phase phase);
    ap = new("ap", this);
endfunction

task ahb_monitor::run_phase(uvm_phase phase);
    ahb_seq_item item;
    ahb_seq_item cloned_item;

    item = ahb_seq_item::type_id::create("item");

    forever begin
        @(posedge AHB.HCLK iff (AHB.HREADY == 1) && (AHB.HTRANS == AHB_NON_SEQ));
        item.HADDR = AHB.HADDR;
        item.HWRITE = ahb_rw_e'(AHB.HWRITE);
        @(posedge AHB.HCLK iff(AHB.HREADY == 1));
        if(item.HWRITE == AHB_WRITE) begin
            item.DATA = AHB.HWDATA;
        end
        else begin
            item.DATA = AHB.HRDATA;
        end
        item.HRESP = ahb_resp_e'(AHB.HRESP);
        // Clone and publish the cloned item to the subscribers
        $cast(cloned_item, item.clone());
        ap.write(cloned_item);
    end
endtask

function void ahb_monitor::report_phase(uvm_phase phase);
    // Might be a good place to do some reporting on no of analysis transactions sent etc
    
endfunction: report_phase
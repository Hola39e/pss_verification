
//------------------------------------------------------------
//   Copyright 2010 Mentor Graphics Corporation
//   All Rights Reserved Worldwide
//
//   Licensed under the Apache License, Version 2.0 (the
//   "License"); you may not use this file except in
//   compliance with the License.  You may obtain a copy of
//   the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in
//   writing, software distributed under the License is
//   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//   CONDITIONS OF ANY KIND, either express or implied.  See
//   the License for the specific language governing
//   permissions and limitations under the License.
//------------------------------------------------------------
//
// Class Description:
//
//
class spi_agent extends uvm_component;

// UVM Factory Registration Macro
//
`uvm_component_utils(spi_agent)

//------------------------------------------
// Data Members
//------------------------------------------
spi_agent_config m_cfg;
//------------------------------------------
// Component Members
//------------------------------------------
uvm_analysis_port #(spi_seq_item) ap;
spi_monitor   m_monitor;
spi_sequencer m_sequencer;
spi_driver    m_driver;
//------------------------------------------
// Methods
//------------------------------------------

// Standard UVM Methods:
extern function new(string name = "spi_agent", uvm_component parent = null);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);

endclass: spi_agent


function spi_agent::new(string name = "spi_agent", uvm_component parent = null);
  super.new(name, parent);
endfunction

// Note the use of get_config() to return a spi_agent_config object
function void spi_agent::build_phase(uvm_phase phase);
  if(!uvm_config_db #(spi_agent_config)::get(this, "", "spi_agent_config", m_cfg)) begin
    `uvm_error("build_phase", "SPI agent config not found")
  end
  // Monitor is always present
  m_monitor = spi_monitor::type_id::create("m_monitor", this);
  // Only build the driver and sequencer if active
  if(m_cfg.active == UVM_ACTIVE) begin
    m_driver = spi_driver::type_id::create("m_driver", this);
    m_sequencer = spi_sequencer::type_id::create("m_sequencer", this);
  end
endfunction: build_phase

function void spi_agent::connect_phase(uvm_phase phase);
  m_monitor.SPI = m_cfg.SPI;
  ap = m_monitor.ap;
  // Only connect the driver and the sequencer if active
  if(m_cfg.active == UVM_ACTIVE) begin
    m_driver.seq_item_port.connect(m_sequencer.seq_item_export);
    m_driver.SPI = m_cfg.SPI;
  end
endfunction: connect_phase

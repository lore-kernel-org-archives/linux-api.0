From: mathieu.poirier@linaro.org
Subject: [PATCH] coresight:  Adding ABI documentation
Date: Mon, 10 Nov 2014 14:06:42 -0700
Message-ID: <1415653602-25347-1-git-send-email-mathieu.poirier@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: gregkh@linuxfoundation.org
Cc: akpm@linux-foundation.org, davem@davemloft.net, joe@perches.com, linux-arm-kernel@lists.infradead.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, mathieu.poirier@linaro.org
List-Id: linux-api@vger.kernel.org

From: Mathieu Poirier <mathieu.poirier@linaro.org>

Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 .../ABI/testing/sysfs-bus-coresight-devices-etb10  |  24 ++
 .../ABI/testing/sysfs-bus-coresight-devices-etm3x  | 253 +++++++++++++++++++++
 .../ABI/testing/sysfs-bus-coresight-devices-funnel |  12 +
 .../ABI/testing/sysfs-bus-coresight-devices-tmc    |   8 +
 MAINTAINERS                                        |   1 +
 5 files changed, 298 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-bus-coresight-devices-etb10
 create mode 100644 Documentation/ABI/testing/sysfs-bus-coresight-devices-etm3x
 create mode 100644 Documentation/ABI/testing/sysfs-bus-coresight-devices-funnel
 create mode 100644 Documentation/ABI/testing/sysfs-bus-coresight-devices-tmc

diff --git a/Documentation/ABI/testing/sysfs-bus-coresight-devices-etb10 b/Documentation/ABI/testing/sysfs-bus-coresight-devices-etb10
new file mode 100644
index 0000000..4b8d6ec
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-bus-coresight-devices-etb10
@@ -0,0 +1,24 @@
+What:		/sys/bus/coresight/devices/<memory_map>.etb/enable_sink
+Date:		November 2014
+KernelVersion:	3.19
+Contact:	Mathieu Poirier <mathieu.poirier@linaro.org>
+Description:	(RW) Add/remove a sink from a trace path.  There can be multiple
+		source for a single sink.
+		ex: echo 1 > /sys/bus/coresight/devices/20010000.etb/enable_sink
+
+What:		/sys/bus/coresight/devices/<memory_map>.etb/status
+Date:		November 2014
+KernelVersion:	3.19
+Contact:	Mathieu Poirier <mathieu.poirier@linaro.org>
+Description:	(R) List various control and status registers.  The specific
+		layout and content is driver specific.
+
+What:		/sys/bus/coresight/devices/<memory_map>.etb/trigger_cntr
+Date:		November 2014
+KernelVersion:	3.19
+Contact:	Mathieu Poirier <mathieu.poirier@linaro.org>
+Description:	(RW) Disables write access to the Trace RAM by stopping the
+		formatter after a defined number of words have been stored
+		following the trigger event. The number of 32-bit words written
+		into the Trace RAM following the trigger event is equal to the
+		value stored in this register+1 (from ARM ETB-TRM).
diff --git a/Documentation/ABI/testing/sysfs-bus-coresight-devices-etm3x b/Documentation/ABI/testing/sysfs-bus-coresight-devices-etm3x
new file mode 100644
index 0000000..b4d0b99
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-bus-coresight-devices-etm3x
@@ -0,0 +1,253 @@
+What:		/sys/bus/coresight/devices/<memory_map>.[etm|ptm]/enable_source
+Date:		November 2014
+KernelVersion:	3.19
+Contact:	Mathieu Poirier <mathieu.poirier@linaro.org>
+Description:	(RW) Enable/disable tracing on this specific trace entiry.
+		Enabling a source implies the source has been configured
+		properly and a sink has been identidifed for it.  The path
+		of coresight components linking the source to the sink is
+		configured and managed automatically by the coresight framework.
+
+What:		/sys/bus/coresight/devices/<memory_map>.[etm|ptm]/status
+Date:		November 2014
+KernelVersion:	3.19
+Contact:	Mathieu Poirier <mathieu.poirier@linaro.org>
+Description:	(R) List various control and status registers.  The specific
+		layout and content is driver specific.
+
+What:		/sys/bus/coresight/devices/<memory_map>.[etm|ptm]/addr_idx
+Date:		November 2014
+KernelVersion:	3.19
+Contact:	Mathieu Poirier <mathieu.poirier@linaro.org>
+Description:	Select which address comparator or pair (of comparators) to
+		work with.
+
+What:		/sys/bus/coresight/devices/<memory_map>.[etm|ptm]/addr_acctype
+Date:		November 2014
+KernelVersion:	3.19
+Contact:	Mathieu Poirier <mathieu.poirier@linaro.org>
+Description:	(RW) Used in conjunction with @addr_idx.  Specifies
+		characteristics about the address comparator being configure,
+		for example the access type, the kind of instruction to trace,
+		processor contect ID to trigger on, etc.  Individual fields in
+		the access type register may vary on the version of the trace
+		entity.
+
+What:		/sys/bus/coresight/devices/<memory_map>.[etm|ptm]/addr_range
+Date:		November 2014
+KernelVersion:	3.19
+Contact:	Mathieu Poirier <mathieu.poirier@linaro.org>
+Description:	(RW) Used in conjunction with @addr_idx.  Specifies the range of
+		addresses to trigger on.  Inclusion or exclusion is specificed
+		in the corresponding access type register.
+
+What:		/sys/bus/coresight/devices/<memory_map>.[etm|ptm]/addr_single
+Date:		November 2014
+KernelVersion:	3.19
+Contact:	Mathieu Poirier <mathieu.poirier@linaro.org>
+Description:	(RW) Used in conjunction with @addr_idx.  Specifies the single
+		address to trigger on, highly influenced by the configuration
+		options of the corresponding access type register.
+
+What:		/sys/bus/coresight/devices/<memory_map>.[etm|ptm]/addr_start
+Date:		November 2014
+KernelVersion:	3.19
+Contact:	Mathieu Poirier <mathieu.poirier@linaro.org>
+Description:	(RW) Used in conjunction with @addr_idx.  Specifies the single
+		address to start tracing on, highly influenced by the
+		configuration options of the corresponding access type register.
+
+What:		/sys/bus/coresight/devices/<memory_map>.[etm|ptm]/addr_stop
+Date:		November 2014
+KernelVersion:	3.19
+Contact:	Mathieu Poirier <mathieu.poirier@linaro.org>
+Description:	(RW) Used in conjunction with @addr_idx.  Specifies the single
+		address to stop tracing on, highly influenced by the
+		configuration options of the corresponding access type register.
+
+What:		/sys/bus/coresight/devices/<memory_map>.[etm|ptm]/cntr_idx
+Date:		November 2014
+KernelVersion:	3.19
+Contact:	Mathieu Poirier <mathieu.poirier@linaro.org>
+Description:	(RW) Specifies the counter to work on.
+
+What:		/sys/bus/coresight/devices/<memory_map>.[etm|ptm]/cntr_event
+Date:		November 2014
+KernelVersion:	3.19
+Contact:	Mathieu Poirier <mathieu.poirier@linaro.org>
+Description: 	(RW) Used in conjunction with cntr_idx, give access to the
+		counter event register.
+
+What:		/sys/bus/coresight/devices/<memory_map>.[etm|ptm]/cntr_val
+Date:		November 2014
+KernelVersion:	3.19
+Contact:	Mathieu Poirier <mathieu.poirier@linaro.org>
+Description: 	(RW) Used in conjunction with cntr_idx, give access to the
+		counter value register.
+
+What:		/sys/bus/coresight/devices/<memory_map>.[etm|ptm]/cntr_rld_val
+Date:		November 2014
+KernelVersion:	3.19
+Contact:	Mathieu Poirier <mathieu.poirier@linaro.org>
+Description: 	(RW) Used in conjunction with cntr_idx, give access to the
+		counter reload value register.
+
+What:		/sys/bus/coresight/devices/<memory_map>.[etm|ptm]/cntr_rld_event
+Date:		November 2014
+KernelVersion:	3.19
+Contact:	Mathieu Poirier <mathieu.poirier@linaro.org>
+Description: 	(RW) Used in conjunction with cntr_idx, give access to the
+		counter reload event register.
+
+What:		/sys/bus/coresight/devices/<memory_map>.[etm|ptm]/ctxid_idx
+Date:		November 2014
+KernelVersion:	3.19
+Contact:	Mathieu Poirier <mathieu.poirier@linaro.org>
+Description: 	(RW) Specifies the index of the context ID register to be
+		selected.
+
+What:		/sys/bus/coresight/devices/<memory_map>.[etm|ptm]/ctxid_mask
+Date:		November 2014
+KernelVersion:	3.19
+Contact:	Mathieu Poirier <mathieu.poirier@linaro.org>
+Description: 	(RW) Mask to apply to all the context ID comparator.
+
+What:		/sys/bus/coresight/devices/<memory_map>.[etm|ptm]/ctxid_val
+Date:		November 2014
+KernelVersion:	3.19
+Contact:	Mathieu Poirier <mathieu.poirier@linaro.org>
+Description: 	(RW) Used with the ctxid_idx, specify with context ID to trigger
+		on.
+
+What:		/sys/bus/coresight/devices/<memory_map>.[etm|ptm]/enable_event
+Date:		November 2014
+KernelVersion:	3.19
+Contact:	Mathieu Poirier <mathieu.poirier@linaro.org>
+Description: 	(RW) Defines which event triggers a trace.
+
+What:		/sys/bus/coresight/devices/<memory_map>.[etm|ptm]/etmsr
+Date:		November 2014
+KernelVersion:	3.19
+Contact:	Mathieu Poirier <mathieu.poirier@linaro.org>
+Description: 	(RW) Gives access to the ETM status register, which holds
+		programming information and status on certains events.
+
+What:		/sys/bus/coresight/devices/<memory_map>.[etm|ptm]/fifofull_level
+Date:		November 2014
+KernelVersion:	3.19
+Contact:	Mathieu Poirier <mathieu.poirier@linaro.org>
+Description: 	(RW) Number of byte left in the fifo before considering it full.
+		Depending on the tracer's version, can also hold threshold for
+		data suppression.
+
+What:		/sys/bus/coresight/devices/<memory_map>.[etm|ptm]/mode
+Date:		November 2014
+KernelVersion:	3.19
+Contact:	Mathieu Poirier <mathieu.poirier@linaro.org>
+Description: 	(RW) Interface with the driver's 'mode' field, controlling
+		various aspect of the trace entity such as time stamping,
+		context ID size and cycle accurate tracing.  Driver specific
+		and bound to change depending on the driver.
+
+What:		/sys/bus/coresight/devices/<memory_map>.[etm|ptm]/nr_addr_cmp
+Date:		November 2014
+KernelVersion:	3.19
+Contact:	Mathieu Poirier <mathieu.poirier@linaro.org>
+Description: 	(R) Provides the number of address comparators pairs accessible
+		on a trace unit, as specified by bit 3:0 of register ETMCCR.
+
+What:		/sys/bus/coresight/devices/<memory_map>.[etm|ptm]/nr_cntr
+Date:		November 2014
+KernelVersion:	3.19
+Contact:	Mathieu Poirier <mathieu.poirier@linaro.org>
+Description: 	(R) Provides the number of counters accessible on a trace unit,
+		as specified by bit 15:13 of register ETMCCR.
+
+What:		/sys/bus/coresight/devices/<memory_map>.[etm|ptm]/nr_ctxid_cmp
+Date:		November 2014
+KernelVersion:	3.19
+Contact:	Mathieu Poirier <mathieu.poirier@linaro.org>
+Description: 	(R) Provides the number of context ID comparator available on a
+		trace unit, as specified by bit 25:24 of register ETMCCR.
+
+What:		/sys/bus/coresight/devices/<memory_map>.[etm|ptm]/reset
+Date:		November 2014
+KernelVersion:	3.19
+Contact:	Mathieu Poirier <mathieu.poirier@linaro.org>
+Description: 	(W) Cancels all configuration on a trace unit and set it back
+		to its boot configuration.
+
+What:		/sys/bus/coresight/devices/<memory_map>.[etm|ptm]/seq_12_event
+Date:		November 2014
+KernelVersion:	3.19
+Contact:	Mathieu Poirier <mathieu.poirier@linaro.org>
+Description: 	(RW) Defines the event that causes the sequencer to transition
+		from state 1 to state 2.
+
+What:		/sys/bus/coresight/devices/<memory_map>.[etm|ptm]/seq_13_event
+Date:		November 2014
+KernelVersion:	3.19
+Contact:	Mathieu Poirier <mathieu.poirier@linaro.org>
+Description: 	(RW) Defines the event that causes the sequencer to transition
+		from state 1 to state 3.
+
+What:		/sys/bus/coresight/devices/<memory_map>.[etm|ptm]/seq_21_event
+Date:		November 2014
+KernelVersion:	3.19
+Contact:	Mathieu Poirier <mathieu.poirier@linaro.org>
+Description: 	(RW) Defines the event that causes the sequencer to transition
+		from state 2 to state 1.
+
+What:		/sys/bus/coresight/devices/<memory_map>.[etm|ptm]/seq_23_event
+Date:		November 2014
+KernelVersion:	3.19
+Contact:	Mathieu Poirier <mathieu.poirier@linaro.org>
+Description: 	(RW) Defines the event that causes the sequencer to transition
+		from state 2 to state 3.
+
+What:		/sys/bus/coresight/devices/<memory_map>.[etm|ptm]/seq_31_event
+Date:		November 2014
+KernelVersion:	3.19
+Contact:	Mathieu Poirier <mathieu.poirier@linaro.org>
+Description: 	(RW) Defines the event that causes the sequencer to transition
+		from state 3 to state 1.
+
+What:		/sys/bus/coresight/devices/<memory_map>.[etm|ptm]/seq_32_event
+Date:		November 2014
+KernelVersion:	3.19
+Contact:	Mathieu Poirier <mathieu.poirier@linaro.org>
+Description: 	(RW) Defines the event that causes the sequencer to transition
+		from state 3 to state 2.
+
+What:		/sys/bus/coresight/devices/<memory_map>.[etm|ptm]/curr_seq_state
+Date:		November 2014
+KernelVersion:	3.19
+Contact:	Mathieu Poirier <mathieu.poirier@linaro.org>
+Description: 	(R) Holds the current state of the sequencer.
+
+What:		/sys/bus/coresight/devices/<memory_map>.[etm|ptm]/sync_freq
+Date:		November 2014
+KernelVersion:	3.19
+Contact:	Mathieu Poirier <mathieu.poirier@linaro.org>
+Description: 	(RW) Holds the trace synchronization frequency value - must be
+		programmed with the various implementation behavior in mind.
+
+What:		/sys/bus/coresight/devices/<memory_map>.[etm|ptm]/timestamp_event
+Date:		November 2014
+KernelVersion:	3.19
+Contact:	Mathieu Poirier <mathieu.poirier@linaro.org>
+Description: 	(RW) Defines an event that requests the insertion of a timestamp
+		into the trace stream.
+
+What:		/sys/bus/coresight/devices/<memory_map>.[etm|ptm]/traceid
+Date:		November 2014
+KernelVersion:	3.19
+Contact:	Mathieu Poirier <mathieu.poirier@linaro.org>
+Description: 	(RW) Holds the trace ID that will appear in the trace stream
+		coming from this trace entity.
+
+What:		/sys/bus/coresight/devices/<memory_map>.[etm|ptm]/trigger_event
+Date:		November 2014
+KernelVersion:	3.19
+Contact:	Mathieu Poirier <mathieu.poirier@linaro.org>
+Description: 	(RW) Define the event that controls the trigger.
diff --git a/Documentation/ABI/testing/sysfs-bus-coresight-devices-funnel b/Documentation/ABI/testing/sysfs-bus-coresight-devices-funnel
new file mode 100644
index 0000000..d75acda
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-bus-coresight-devices-funnel
@@ -0,0 +1,12 @@
+What:		/sys/bus/coresight/devices/<memory_map>.funnel/funnel_ctrl
+Date:		November 2014
+KernelVersion:	3.19
+Contact:	Mathieu Poirier <mathieu.poirier@linaro.org>
+Description:	(RW) Enables the slave ports and defines the hold time of the
+		slave ports.
+
+What:		/sys/bus/coresight/devices/<memory_map>.funnel/priority
+Date:		November 2014
+KernelVersion:	3.19
+Contact:	Mathieu Poirier <mathieu.poirier@linaro.org>
+Description:	(RW) Defines input port priority order.
diff --git a/Documentation/ABI/testing/sysfs-bus-coresight-devices-tmc b/Documentation/ABI/testing/sysfs-bus-coresight-devices-tmc
new file mode 100644
index 0000000..f38cded5
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-bus-coresight-devices-tmc
@@ -0,0 +1,8 @@
+What:		/sys/bus/coresight/devices/<memory_map>.tmc/trigger_cntr
+Date:		November 2014
+KernelVersion:	3.19
+Contact:	Mathieu Poirier <mathieu.poirier@linaro.org>
+Description:	(RW) Disables write access to the Trace RAM by stopping the
+		formatter after a defined number of words have been stored
+		following the trigger event. Additional interface for this
+		driver are expected to be added as it matures.
diff --git a/MAINTAINERS b/MAINTAINERS
index 3995263..7d18080 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -925,6 +925,7 @@ S:	Maintained
 F:	drivers/coresight/*
 F:	Documentation/trace/coresight.txt
 F:	Documentation/devicetree/bindings/arm/coresight.txt
+F:	Documentation/ABI/testing/sysfs-bus-coresight-devices-*
 
 ARM/CORGI MACHINE SUPPORT
 M:	Richard Purdie <rpurdie@rpsys.net>
-- 
1.9.1

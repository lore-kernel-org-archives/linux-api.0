From: Alexei Starovoitov <ast@fb.com>
Subject: [PATCH v7 bpf-next 02/10] net/mediatek: disambiguate mt76 vs mt7601u trace events
Date: Tue, 27 Mar 2018 19:10:57 -0700
Message-ID: <20180328021105.4061744-3-ast@fb.com>
References: <20180328021105.4061744-1-ast@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180328021105.4061744-1-ast@fb.com>
Sender: netdev-owner@vger.kernel.org
To: davem@davemloft.net
Cc: daniel@iogearbox.net, torvalds@linux-foundation.org, peterz@infradead.org, rostedt@goodmis.org, mathieu.desnoyers@efficios.com, netdev@vger.kernel.org, kernel-team@fb.com, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

two trace events defined with the same name and both unused.
They conflict in allyesconfig build. Rename one of them.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 drivers/net/wireless/mediatek/mt7601u/trace.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt7601u/trace.h b/drivers/net/wireless/mediatek/mt7601u/trace.h
index 289897300ef0..82c8898b9076 100644
--- a/drivers/net/wireless/mediatek/mt7601u/trace.h
+++ b/drivers/net/wireless/mediatek/mt7601u/trace.h
@@ -34,7 +34,7 @@
 #define REG_PR_FMT	"%04x=%08x"
 #define REG_PR_ARG	__entry->reg, __entry->val
 
-DECLARE_EVENT_CLASS(dev_reg_evt,
+DECLARE_EVENT_CLASS(dev_reg_evtu,
 	TP_PROTO(struct mt7601u_dev *dev, u32 reg, u32 val),
 	TP_ARGS(dev, reg, val),
 	TP_STRUCT__entry(
@@ -51,12 +51,12 @@ DECLARE_EVENT_CLASS(dev_reg_evt,
 	)
 );
 
-DEFINE_EVENT(dev_reg_evt, reg_read,
+DEFINE_EVENT(dev_reg_evtu, reg_read,
 	TP_PROTO(struct mt7601u_dev *dev, u32 reg, u32 val),
 	TP_ARGS(dev, reg, val)
 );
 
-DEFINE_EVENT(dev_reg_evt, reg_write,
+DEFINE_EVENT(dev_reg_evtu, reg_write,
 	TP_PROTO(struct mt7601u_dev *dev, u32 reg, u32 val),
 	TP_ARGS(dev, reg, val)
 );
-- 
2.9.5

From: Alexei Starovoitov <ast@fb.com>
Subject: [PATCH v6 bpf-next 03/11] net/mac802154: disambiguate mac80215 vs mac802154 trace events
Date: Mon, 26 Mar 2018 19:46:58 -0700
Message-ID: <20180327024706.2064725-4-ast@fb.com>
References: <20180327024706.2064725-1-ast@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180327024706.2064725-1-ast@fb.com>
Sender: netdev-owner@vger.kernel.org
To: davem@davemloft.net
Cc: daniel@iogearbox.net, torvalds@linux-foundation.org, peterz@infradead.org, rostedt@goodmis.org, netdev@vger.kernel.org, kernel-team@fb.com, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

two trace events defined with the same name and both unused.
They conflict in allyesconfig build. Rename one of them.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 net/mac802154/trace.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/mac802154/trace.h b/net/mac802154/trace.h
index 2c8a43d3607f..df855c33daf2 100644
--- a/net/mac802154/trace.h
+++ b/net/mac802154/trace.h
@@ -33,7 +33,7 @@
 
 /* Tracing for driver callbacks */
 
-DECLARE_EVENT_CLASS(local_only_evt,
+DECLARE_EVENT_CLASS(local_only_evt4,
 	TP_PROTO(struct ieee802154_local *local),
 	TP_ARGS(local),
 	TP_STRUCT__entry(
@@ -45,7 +45,7 @@ DECLARE_EVENT_CLASS(local_only_evt,
 	TP_printk(LOCAL_PR_FMT, LOCAL_PR_ARG)
 );
 
-DEFINE_EVENT(local_only_evt, 802154_drv_return_void,
+DEFINE_EVENT(local_only_evt4, 802154_drv_return_void,
 	TP_PROTO(struct ieee802154_local *local),
 	TP_ARGS(local)
 );
@@ -65,12 +65,12 @@ TRACE_EVENT(802154_drv_return_int,
 		  __entry->ret)
 );
 
-DEFINE_EVENT(local_only_evt, 802154_drv_start,
+DEFINE_EVENT(local_only_evt4, 802154_drv_start,
 	TP_PROTO(struct ieee802154_local *local),
 	TP_ARGS(local)
 );
 
-DEFINE_EVENT(local_only_evt, 802154_drv_stop,
+DEFINE_EVENT(local_only_evt4, 802154_drv_stop,
 	TP_PROTO(struct ieee802154_local *local),
 	TP_ARGS(local)
 );
-- 
2.9.5

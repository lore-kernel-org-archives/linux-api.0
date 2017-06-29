From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH 2/4] swait: add the missing killable swaits
Date: Fri, 30 Jun 2017 00:50:03 +0200
Message-ID: <20170629225003.GU21846@wotan.suse.de>
References: <20170629133530.GA14747@kroah.com>
 <alpine.DEB.2.20.1706291545320.1861@nanos>
 <CA+55aFxkp51RipBj7__T0hoy6tAdXJxTqjMdhnnnkKm71P6HuQ@mail.gmail.com>
 <20170629174046.GC3954@linux-80c1.suse>
 <CA+55aFz=6XmH5MfwKLN6MZSyG8fAk-aD67mbDc1ZaKySzsq8aw@mail.gmail.com>
 <20170629183339.GD3954@linux-80c1.suse>
 <CA+55aFz8Mhx+A-g-5yOG-O1ZLRUR_fpeeA4iBNGH8EnDBZEdpA@mail.gmail.com>
 <20170629194015.GQ21846@wotan.suse.de>
 <20170629194455.GR21846@wotan.suse.de>
 <20170629135822.366fd67a@cakuba.netronome.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170629135822.366fd67a@cakuba.netronome.com>
Sender: stable-owner@vger.kernel.org
To: Jakub Kicinski <jakub.kicinski@netronome.com>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, nbroeking@me.com, Linus Torvalds <torvalds@linux-foundation.org>, Davidlohr Bueso <dave@stgolabs.net>, Thomas Gleixner <tglx@linutronix.de>, Greg KH <gregkh@linuxfoundation.org>, mfuzzey@parkeon.com, "Eric W. Biederman" <ebiederm@xmission.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Daniel Wagner <wagi@monom.org>, David Woodhouse <dwmw2@infradead.org>, jewalt@lgsinnovations.com, rafal@milecki.pl, Arend Van Spriel <arend.vanspriel@broadcom.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, "Li, Yi" <yi1.li@linux.intel.com>, atull@kernel.org, Moritz Fischer <moritz.fischer@ettus.com>, Petr Mladek <pmladek@suse.com>, Johannes Berg <johannes.berg@intel.com>, Emmanuel Grumbach <emmanuel.grumbach@intel.com>, Coel
List-Id: linux-api@vger.kernel.org

On Thu, Jun 29, 2017 at 01:58:22PM -0700, Jakub Kicinski wrote:
> On Thu, 29 Jun 2017 21:44:55 +0200, Luis R. Rodriguez wrote:
> > > Since this swake_up() --> swake_up_all() reportedly *fixed* the one wake up
> > > issue it would seem this does queue [0]. That said, I don't see any simple tests
> > > tools/testing/selftests/swait but then again we don't have test for regular
> > > waits either...
> > > 
> > > [0] https://bugzilla.kernel.org/show_bug.cgi?id=195477  
> > 
> > I should also note that the swake_up_all() should have only helped in cases where
> > 3 cards were used, as if only 2 were used that should have been covered by just
> > the swake_up(). Unless of course I hear otherwise by the reporter, Nicolas or
> > from Jakub.
> 
> I was hitting this with 2 cards.

Thanks!

Thing is I'm not convinced the issue with 2 cards was the swake_up() Vs
swake_up_all() in this case though. Let's recall also the missing wake up on
errors! And the fact that netronome has optional firmware, which naturally can
fail.

So could the issue with 2 cards instead of the miss of a wake up on error due
to batched requests ? If so then that still would not put blame on the
swake_up()!

We can find out by you testing the series I just posted [0] and if that did not
fix the issue then try this patch, which I do expect to actually have fixed
most issues considering optional firmware.

ie, I expect the combination of both to fix your issues, not just the last
series I just posted [0]. If you want this in git form you can find all of
the patches bundled on the 20170629-fw-fixes-wait-v4 branch [1]. I just
wrote this patch it but it seems to have not broken the tests:

$ sudo tools/testing/selftests/firmware/fw_fallback.sh 
tools/testing/selftests/firmware/fw_fallback.sh: timeout works
tools/testing/selftests/firmware/fw_fallback.sh: firmware comparison works
tools/testing/selftests/firmware/fw_fallback.sh: fallback mechanism works
tools/testing/selftests/firmware/fw_fallback.sh: cancelling fallback mechanism works
tools/testing/selftests/firmware/fw_fallback.sh: custom fallback loading mechanism works
tools/testing/selftests/firmware/fw_fallback.sh: cancelling custom fallback mechanism works
tools/testing/selftests/firmware/fw_fallback.sh: SIGCHLD on sync ignored as expected

$ sudo tools/testing/selftests/firmware/fw_filesystem.sh 
tools/testing/selftests/firmware/fw_filesystem.sh: timeout works
tools/testing/selftests/firmware/fw_filesystem.sh: filesystem loading works
tools/testing/selftests/firmware/fw_filesystem.sh: async filesystem loading works

[0] https://lkml.kernel.org/r/20170629205151.5329-1-mcgrof@kernel.org
[1] https://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux-next.git/log/?h=20170629-fw-fixes-wait-v4

 Luis

>From cb7fee12c6d539405793e883dfd79e0b21c2baad Mon Sep 17 00:00:00 2001
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Date: Thu, 29 Jun 2017 15:19:04 -0700
Subject: [RFT] firmware: send wake up on failure for batched requests

Fix batched requests from waiting forever on failure.

The firmware API supports "batched requests" which means requests with
the same name share the same lookup effort. They wait for the first
request to complete, however they are set to always wait for what seem
to be forever (MAX_SCHEDULE_TIMEOUT).

We currently handle informing waited batched requests on success but we
never seem to have sent smoke signals of any kind on failure! This
should mean secondary requests batched in seem to just wait forever when
the request fails.

For device drivers with optional firmware schemes (Intel, or Netronome),
this could mean that when you boot a system with multiple cards the
firmware will seem to never load on the system, or that the card is just
not responsive even the driver initialized. Due to differences in scheduling
possible this should not always trigger, so triggering batched requests
actually needs to be triggered for this to be an issue.

Its reported that at least with the Intel WiFi cards on one system this
issue was creeping up 50% of the boots [0].

[0] https://bugzilla.kernel.org/show_bug.cgi?id=195477

Reported-by: Nicolas <nbroeking@me.com>
Reported-by: John Ewalt  <jewalt@lgsinnovations.com>
Reported-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
---
 drivers/base/firmware_class.c | 40 ++++++++++++++++++++++++++++++++--------
 1 file changed, 32 insertions(+), 8 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index d3d071dbd2a5..40d1351660c0 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -152,28 +152,27 @@ static void __fw_state_set(struct fw_state *fw_st,
 	__fw_state_set(fw_st, FW_STATUS_LOADING)
 #define fw_state_done(fw_st)					\
 	__fw_state_set(fw_st, FW_STATUS_DONE)
+#define fw_state_aborted(fw_st)					\
+	__fw_state_set(fw_st, FW_STATUS_ABORTED)
 #define fw_state_wait(fw_st)					\
 	__fw_state_wait_common(fw_st, MAX_SCHEDULE_TIMEOUT)
 
-#ifndef CONFIG_FW_LOADER_USER_HELPER
-
-#define fw_state_is_aborted(fw_st)	false
-
-#else /* CONFIG_FW_LOADER_USER_HELPER */
-
 static int __fw_state_check(struct fw_state *fw_st, enum fw_status status)
 {
 	return fw_st->status == status;
 }
 
+#define fw_state_is_aborted(fw_st)				\
+	__fw_state_check(fw_st, FW_STATUS_ABORTED)
+
+#ifdef CONFIG_FW_LOADER_USER_HELPER
+
 #define fw_state_aborted(fw_st)					\
 	__fw_state_set(fw_st, FW_STATUS_ABORTED)
 #define fw_state_is_done(fw_st)					\
 	__fw_state_check(fw_st, FW_STATUS_DONE)
 #define fw_state_is_loading(fw_st)				\
 	__fw_state_check(fw_st, FW_STATUS_LOADING)
-#define fw_state_is_aborted(fw_st)				\
-	__fw_state_check(fw_st, FW_STATUS_ABORTED)
 #define fw_state_wait_timeout(fw_st, timeout)			\
 	__fw_state_wait_common(fw_st, timeout)
 
@@ -332,6 +331,7 @@ static struct firmware_buf *__fw_lookup_buf(const char *fw_name)
 	return NULL;
 }
 
+/* Returns 1 for batching firmware requests with the same name */
 static int fw_lookup_and_allocate_buf(const char *fw_name,
 				      struct firmware_cache *fwc,
 				      struct firmware_buf **buf, void *dbuf,
@@ -345,6 +345,7 @@ static int fw_lookup_and_allocate_buf(const char *fw_name,
 		kref_get(&tmp->ref);
 		spin_unlock(&fwc->lock);
 		*buf = tmp;
+		/* requests are batched ! */
 		return 1;
 	}
 	tmp = __allocate_fw_buf(fw_name, fwc, dbuf, size);
@@ -1200,6 +1201,28 @@ _request_firmware_prepare(struct firmware **firmware_p, const char *name,
 	return 1; /* need to load */
 }
 
+/*
+ * Batched requests need only one wake, we need to do this step last due to the
+ * fallback mechanism. The buf is protected with kref_get(), and it won't be
+ * released until the last user calls release_firmware().
+ *
+ * Failed batched requests are possible as well, in such cases we just share
+ * the struct firmware_buf and won't release it until all requests are woken
+ * and have gone through this same path.
+ */
+static void fw_abort_batch_reqs(struct firmware *fw)
+{
+	struct firmware_buf *buf;
+
+	/* Loaded directly? */
+	if (!fw || !fw->priv)
+		return;
+
+	buf = fw->priv;
+	if (!fw_state_is_aborted(&buf->fw_st))
+		fw_state_aborted(&buf->fw_st);
+}
+
 /* called from request_firmware() and request_firmware_work_func() */
 static int
 _request_firmware(const struct firmware **firmware_p, const char *name,
@@ -1243,6 +1266,7 @@ _request_firmware(const struct firmware **firmware_p, const char *name,
 
  out:
 	if (ret < 0) {
+		fw_abort_batch_reqs(fw);
 		release_firmware(fw);
 		fw = NULL;
 	}
-- 
2.11.0

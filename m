From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [PATCH 0/4] firmware: fix fallback mechanism by ignoring SIGCHLD
Date: Wed, 14 Jun 2017 15:20:13 -0700
Message-ID: <20170614222017.14653-1-mcgrof@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: gregkh@linuxfoundation.org
Cc: mfuzzey@parkeon.com, ebiederm@xmission.com, dmitry.torokhov@gmail.com, wagi@monom.org, dwmw2@infradead.org, jewalt@lgsinnovations.com, rafal@milecki.pl, arend.vanspriel@broadcom.com, rjw@rjwysocki.net, yi1.li@linux.intel.com, atull@kernel.org, moritz.fischer@ettus.com, pmladek@suse.com, johannes.berg@intel.com, emmanuel.grumbach@intel.com, luciano.coelho@intel.com, kvalo@codeaurora.org, luto@kernel.org, torvalds@linux-foundation.org, keescook@chromium.org, takahiro.akashi@linaro.org, dhowells@redhat.com, pjones@redhat.com, hdegoede@redhat.com, alan@linux.intel.com, tytso@mit.edu, mtk.manpages@gmail.com, paul.gortmaker@windriver.com, mtosatti@redhat.com, mawilcox@microsoft.com, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, L
List-Id: linux-api@vger.kernel.org

Martin reported an issue with Android where if sysfs is used to trigger a sync
fw load which *relies* on the fallback mechanism and a background job completes
while the trigger is ongoing in the foreground it will immediately fail the fw
request.  The issue can be observed in this simple test script using the
test_firmware driver:

	set -e
	/etc/init.d/udev stop
	modprobe test_firmware
	DIR=/sys/devices/virtual/misc/test_firmware
	echo 10 >/sys/class/firmware/timeout
	sleep 2 &
	echo -n "does-not-exist-file.bin" > "$DIR"/trigger_request

The background sleep triggers the SIGCHLD signal and we fail the firmware
request on the fallback mechanism. This was due to the type of wait used which
captures all signals, but we currently lack the killable swaits which would
only allow killing the fallback wait on SIGKILL. This adds the missing killable
swaits and fixes the firmware API to use it. This goes along with a test case to
demo the issue clearly and how its fixed afterwards.  Lastly, ensure to use
-EINTR when interrupted so callers can distinguish between an interrupted
failure and other types of failure.

As suggested I've tagged the addition of the killable swaits and the firmware
fix as stable. Between v4.0 and v4.10 the stable fix is to instead change
the firmware to use wait_for_completion_killable_timeout() as the firmware
API was only converted to swait as of v4.10.

The last patch must be applied only after the killable wait is applied to
ensure only SIGKILL triggers an interruption. Otherwise it has been observed
using -EINTR on other signals like SIGCHLD will trigger a restart of the call,
if a sysfs write() is used to trigger the sync firmware request. This might be
due what signal(7) says about using the SA_RESTART flag when write() is called,
in such cases the call will be automatically restarted after the signal handler
returns. The excemption here naturally seems to be on SIGKILL.

Note that although I *feared* this might implicate any use of non-killable waits
on other system calls, such as finit_module(), initial testing confirms this to
not be the case.  For instance replacing the echo with modprobe on a module
which does the same on init does not present the same issues. This could be due
to the special SA_RESTART flag case on write() as noted above and sysfs...
however, its not perfectly clear yet to me.

As usual these patches are on my linux-next git tree, they are on the
20170614-fw-fixes branch based on linux-next 20170614 [0].

[0] https://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux-next.git/log/?h=20170614-fw-fixes

Luis R. Rodriguez (4):
  test_firmware: add test case for SIGCHLD on sync fallback
  swait: add the missing killable swaits
  firmware: avoid invalid fallback aborts by using killable swait
  firmware: send -EINTR on signal abort on fallback mechanism

 drivers/base/firmware_class.c                   | 11 +++++----
 include/linux/swait.h                           | 25 ++++++++++++++++++++
 tools/testing/selftests/firmware/fw_fallback.sh | 31 +++++++++++++++++++++++++
 3 files changed, 63 insertions(+), 4 deletions(-)

-- 
2.11.0

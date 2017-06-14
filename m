From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [PATCH 1/4] test_firmware: add test case for SIGCHLD on sync fallback
Date: Wed, 14 Jun 2017 15:20:14 -0700
Message-ID: <20170614222017.14653-2-mcgrof@kernel.org>
References: <20170614222017.14653-1-mcgrof@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170614222017.14653-1-mcgrof@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: gregkh@linuxfoundation.org
Cc: mfuzzey@parkeon.com, ebiederm@xmission.com, dmitry.torokhov@gmail.com, wagi@monom.org, dwmw2@infradead.org, jewalt@lgsinnovations.com, rafal@milecki.pl, arend.vanspriel@broadcom.com, rjw@rjwysocki.net, yi1.li@linux.intel.com, atull@kernel.org, moritz.fischer@ettus.com, pmladek@suse.com, johannes.berg@intel.com, emmanuel.grumbach@intel.com, luciano.coelho@intel.com, kvalo@codeaurora.org, luto@kernel.org, torvalds@linux-foundation.org, keescook@chromium.org, takahiro.akashi@linaro.org, dhowells@redhat.com, pjones@redhat.com, hdegoede@redhat.com, alan@linux.intel.com, tytso@mit.edu, mtk.manpages@gmail.com, paul.gortmaker@windriver.com, mtosatti@redhat.com, mawilcox@microsoft.com, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, L
List-Id: linux-api@vger.kernel.org

It has been reported that SIGCHLD will trigger an immediate abort
on sync firmware requests which rely on the sysfs interface for a
trigger. This is unexpected behaviour, this reproduces this issue.

This test case currenty fails.

Reported-by: Martin Fuzzey <mfuzzey@parkeon.com>
Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
---
 tools/testing/selftests/firmware/fw_fallback.sh | 31 +++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/tools/testing/selftests/firmware/fw_fallback.sh b/tools/testing/selftests/firmware/fw_fallback.sh
index 2e4c22d5abf7..8f511035f783 100755
--- a/tools/testing/selftests/firmware/fw_fallback.sh
+++ b/tools/testing/selftests/firmware/fw_fallback.sh
@@ -134,6 +134,27 @@ load_fw_custom_cancel()
 	wait
 }
 
+load_fw_fallback_with_child()
+{
+	local name="$1"
+	local file="$2"
+
+	# This is the value already set but we want to be explicit
+	echo 4 >/sys/class/firmware/timeout
+
+	sleep 1 &
+	SECONDS_BEFORE=$(date +%s)
+	echo -n "$name" >"$DIR"/trigger_request 2>/dev/null
+	SECONDS_AFTER=$(date +%s)
+	SECONDS_DELTA=$(($SECONDS_AFTER - $SECONDS_BEFORE))
+	if [ "$SECONDS_DELTA" -lt 4 ]; then
+		RET=1
+	else
+		RET=0
+	fi
+	wait
+	return $RET
+}
 
 trap "test_finish" EXIT
 
@@ -221,4 +242,14 @@ else
 	echo "$0: cancelling custom fallback mechanism works"
 fi
 
+set +e
+load_fw_fallback_with_child "nope-signal-$NAME" "$FW"
+if [ "$?" -eq 0 ]; then
+	echo "$0: SIGCHLD on sync ignored as expected" >&2
+else
+	echo "$0: error - sync firmware request cancelled due to SIGCHLD" >&2
+	exit 1
+fi
+set -e
+
 exit 0
-- 
2.11.0

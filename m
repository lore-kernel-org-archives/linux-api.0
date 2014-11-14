From: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Subject: Re: kdbus: add selftests
Date: Fri, 14 Nov 2014 14:42:10 +1100
Message-ID: <1415936530.26378.2.camel@concordia>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org>
	 <1414620056-6675-13-git-send-email-gregkh@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1414620056-6675-13-git-send-email-gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org, desrt-0xnayjDhYQY@public.gmane.org, hadess-0MeiytkfxGOsTnJN9+BGXg@public.gmane.org, dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org, simon.mcvittie-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org, alban.crequy-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, javier.martinez-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, teg-B22kvLQNl6c@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, 2014-10-29 at 15:00 -0700, Greg Kroah-Hartman wrote:
> From: Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>
> 
> This patch adds a quite extensive test suite for kdbus that checks
> the most important code pathes in the driver. The idea is to extend
> the test suite over time.
> 
> Also, this code can serve as an example implementation to show how to
> use the kernel API from userspace.

Great to see selftests included.

I needed this to get them building:

diff --git a/include/uapi/linux/Kbuild b/include/uapi/linux/Kbuild
index b70237e8bc37..b1438a02e49f 100644
--- a/include/uapi/linux/Kbuild
+++ b/include/uapi/linux/Kbuild
@@ -210,6 +210,7 @@ header-y += ixjuser.h
 header-y += jffs2.h
 header-y += joystick.h
 header-y += kd.h
+header-y += kdbus.h
 header-y += kdev_t.h
 header-y += kernel-page-flags.h
 header-y += kernel.h
diff --git a/tools/testing/selftests/kdbus/Makefile b/tools/testing/selftests/kdbus/Makefile
index 0f6a745202af..96766c12a6e3 100644
--- a/tools/testing/selftests/kdbus/Makefile
+++ b/tools/testing/selftests/kdbus/Makefile
@@ -2,7 +2,7 @@ CFLAGS += -I../../../../usr/include/
 CFLAGS += -I../../../../include/uapi/
 CFLAGS += -std=gnu99
 CFLAGS += -DKBUILD_MODNAME=\"kdbus\" -D_GNU_SOURCE
-LDFLAGS = -pthread -lcap
+LDLIBS = -pthread -lcap
 
 OBJS= \
        kdbus-enum.o            \
@@ -37,7 +37,7 @@ all: kdbus-test
        gcc $(CFLAGS) -c $< -o $@
 
 kdbus-test: $(OBJS)
-       gcc $(CFLAGS) $(LDFLAGS) $^ -o $@
+       gcc $(CFLAGS) $(LDFLAGS) $^ $(LDLIBS) -o $@
 
 run_tests:
        ./kdbus-test


And with that it's all happy on ppc64le:

Testing bus make functions (bus-make) .................................. OK
Testing the HELLO command (hello) ...................................... OK
Testing the BYEBYE command (byebye) .................................... OK
Testing a chat pattern (chat) .......................................... OK
Testing a simple dameon (daemon) ....................................... OK
Testing file descriptor passing (fd-passing) ........................... OK
Testing custom endpoint (endpoint) ..................................... OK
Testing monitor functionality (monitor) ................................ OK
Testing basic name registry functions (name-basics) .................... OK
Testing name registry conflict details (name-conflict) ................. OK
Testing queuing of names (name-queue) .................................. OK
Testing basic message handling (message-basic) ......................... OK
Testing handling of messages with priority (message-prio) .............. OK
Testing timeout (timeout) .............................................. OK
Testing synchronous replies vs. BYEBYE (sync-byebye) ................... OK
Testing synchronous replies (sync-reply) ............................... OK
Testing freeing of memory (message-free) ............................... OK
Testing retrieving connection information (connection-info) ............ OK
Testing updating connection information (connection-update) ............ OK
Testing verifying pools are never writable (writable-pool) ............. OK
Testing policy (policy) ................................................ OK
Testing unprivileged bus access (policy-priv) .......................... OK
Testing policy in user namespaces (policy-ns) .......................... OK
Testing metadata in user namespaces (metadata-ns) ...................... OK
Testing adding of matches by id (match-id-add) ......................... OK
Testing removing of matches by id (match-id-remove) .................... OK
Testing adding of matches by name (match-name-add) ..................... OK
Testing removing of matches by name (match-name-remove) ................ OK
Testing matching for name changes (match-name-change) .................. OK
Testing matching with bloom filters (match-bloom) ...................... OK
Testing activator connections (activator) .............................. OK
Testing creating a domain (domain-make) ................................ OK
Testing benchmark (benchmark) .......................................... OK
Testing race multiple byebyes (race-byebye) ............................ OK
Testing race byebye vs match removal (race-byebye-match) ............... OK

SUMMARY: 35 tests passed, 0 skipped, 0 failed


cheers

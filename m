From: "Hillf Danton" <hillf.zj-gPhfCIXyaqCqndwCJWfcng@public.gmane.org>
Subject: Re: [PATCH v2 00/13] Add kdbus implementation
Date: Fri, 05 Dec 2014 16:49:14 +0800
Message-ID: <015c01d01068$59683870$0c38a950$@alibaba-inc.com>
Reply-To: "Hillf Danton" <hillf.zj-gPhfCIXyaqCqndwCJWfcng@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: zh-cn
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Greg Kroah-Hartman' <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: arnd-r2nGTMty4D4@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org, teg-B22kvLQNl6c@public.gmane.org, jkosina-AlSwsSmVLrQ@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org, dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org, Hillf Danton <hillf.zj-gPhfCIXyaqCqndwCJWfcng@public.gmane.org>, =?GBK?B?1dS2qyi4qNbcKQ==?= <fuzhou.zd-gPhfCIXyaqCqndwCJWfcng@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hey all
> 
> kdbus is a kernel-level IPC implementation that aims for resemblance to
> the the protocol layer with the existing userspace D-Bus daemon while
> enabling some features that couldn't be implemented before in userspace.
> 
[...]
> 
> This can also be found in a git tree, the kdbus branch of char-misc.git at:
>         https://git.kernel.org/cgit/linux/kernel/git/gregkh/char-misc.git/
> 
In the environment:
	Android Kitkat
	Linux-3.4.67
	CPU MTK MT6582 ARMv7 Processor rev 3 (v7l)

root@cwet_td_a800:/ # kdbus-test 
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
Testing message quotas are enforced (message-quota) .................... OK
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
Testing replace of matches with the same cookie (match-replace) ........ OK
Testing adding of matches by name (match-name-add) ..................... OK
Testing removing of matches by name (match-name-remove) ................ OK
Testing matching for name changes (match-name-change) .................. OK
Testing matching with bloom filters (match-bloom) ...................... OK
Testing activator connections (activator) .............................. OK
Testing benchmark (benchmark) .......................................... OK
Testing race multiple byebyes (race-byebye) ............................ OK
Testing race byebye vs match removal (race-byebye-match) ............... OK

SUMMARY: 36 tests passed, 0 skipped, 0 failed


And we like to test newer versions, if any, of kdbus with our phone.

Thanks
Hillf

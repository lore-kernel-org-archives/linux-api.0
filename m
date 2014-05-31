From: Manfred Spraul <manfred@colorfullife.com>
Subject: MSGMNB and MSGMAX: good default values?
Date: Sat, 31 May 2014 19:54:36 +0200
Message-ID: <538A175C.80705@colorfullife.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linux API <linux-api@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Michael Kerrisk <mtk.manpages@gmail.com>, Davidlohr Bueso <davidlohr@hp.com>
List-Id: linux-api@vger.kernel.org

Hi all,

until now, every sysadmin/distro had to update the sysv limits.
For shm, the new proposal is to increase the limits to (nearly) ULONG_MAX.

Right now, I try to create patches that also increase the limits for 
sysv msg, but I got stuck:

- MSGMNI is trivial, just increase it to nearly IPCMNI.

- MSGMNB is not an upper limit, it is actually the default amount of 
data that can be stored in a message queue before senders must sleep.
   Since Linux-0.99.10, it always was 16384.

   A websearch shows that for both db2 and oracle, the recommendation is 
65536.

   It seems that redhat has increased the value to 65536:
https://bugzilla.redhat.com/show_bug.cgi?id=862597

Tuxedo seems to use sysv messages and the documentation warns that too 
large values are harmfull:
http://read.pudn.com/downloads142/doc/618733/tux-a11-80/manual/13-ADM-PERF-Notes.pdf

- MSGMAX: Same issue as above: it was slightly below 4096 and since 2.6 
it is 8192.

Any proposals?
Right now, I would leave MSGMAX and MSGMNB as they are.

--
     Manfred

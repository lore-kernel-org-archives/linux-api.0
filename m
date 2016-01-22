From: Daniel Sangorrin <daniel.sangorrin@toshiba.co.jp>
Subject: [RFC PATCH 0/1] Adding previous syscall context to seccomp
Date: Fri, 22 Jan 2016 15:29:59 +0900
Message-ID: <1453444200-8604-1-git-send-email-daniel.sangorrin@toshiba.co.jp>
Reply-To: kernel-hardening@lists.openwall.com
Content-Transfer-Encoding: 7bit
Return-path: <kernel-hardening-return-2421-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
To: keescook@chromium.org
Cc: luto@amacapital.net, wad@chromium.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, kernel-hardening@lists.openwall.com
List-Id: linux-api@vger.kernel.org

Hi,

During my presentation last year at Linuxcon Japan [1], I released
a proof-of-concept patch [2] for the seccomp subsystem. The main
purpose of that patch was to let applications restrict the order
in which their system calls are requested. In more technical terms,
a host-based anomaly intrusion detection system (HIDS) that uses call
sequence monitoring for detecting unusual patterns. For example,
to detect when the execution flow unexpectedly diverts towards the
'mprotect' syscall, perhaps after a stack overflow.

The main target for the patch was embedded real-time systems
where applications have a high degree of determinism. For that
reason, my original proof-of-concept patch was using bitmaps,
which allow for a constant O(1) overhead (correct me if
I'm wrong but I think the current seccomp-filter implementation
introduces an O(n) overhead proportional to the number of system
calls that one wants to allow or prohibit).

However, I realized that it would be too hard to merge with the
current code. I have adapted my original patch which now allows
BPF filters to retrieve information regarding the previous system
call requested by the application.

The patch can be tested on linux-master as follows (tested
on Debian Jessie x86_64):

  $ sudo vi /usr/include/linux/seccomp.h
   ...
   struct seccomp_data {
   	int nr;
   	int prev_nr; <-- add this entry
  ...
  $ cd samples/seccomp/
  $ make bpf-prev
  $ ./bpf-prev
	parent msgsnd: hello
	parent msgrcv after prctl: hello (128 bytes)
	parent msgsnd: world
	parent msgrcv after msgsnd: world (128 bytes)
	parent msgsnd: this is mars
	child msgrcv after clone: this is mars (128 bytes)
	parent: child 11409 exited with status 0
	Should fail: Bad system call

For simplicity, at the moment the patch only records the last
requested system call. Despite being vulnerable to specially-
crafted mimicry attacks, I think it can deter common attacks
specially during the "initial phase" of the attack (e.g.: a 
return-oriented jump).

It could also be extended with longer call sequences (NGRAMs),
call stack and call site information, or scratch memory for
restricting a system call to the application's initalization
for example. However, I'm not sure if such complexity would
be worth. I would like to know at this early stage if any
of you is interested in this type of approach and what you
think about it.

Thanks,
Daniel

[1] Kernel security hacking for the Internet of Things
http://events.linuxfoundation.jp/sites/events/files/slides/linuxcon-2015-daniel-sangorrin-final.pdf
[2] https://github.com/sangorrin/linuxcon-japan-2015/tree/master/hids

Daniel Sangorrin (1):
  seccomp: provide information about the previous syscall

 include/linux/seccomp.h      |   2 +
 include/uapi/linux/seccomp.h |   2 +
 kernel/seccomp.c             |  10 +++
 samples/seccomp/.gitignore   |   1 +
 samples/seccomp/Makefile     |   9 ++-
 samples/seccomp/bpf-prev.c   | 160 +++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 183 insertions(+), 1 deletion(-)
 create mode 100644 samples/seccomp/bpf-prev.c

-- 
2.1.4

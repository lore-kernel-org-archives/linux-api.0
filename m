From: "Daniel Sangorrin" <daniel.sangorrin@toshiba.co.jp>
Subject: RE: [RFC PATCH 1/1] seccomp: provide information about the previous syscall
Date: Mon, 25 Jan 2016 12:39:23 +0900
Message-ID: <001701d15721$fb9888b0$f2c99a10$@toshiba.co.jp>
References: <1453444200-8604-1-git-send-email-daniel.sangorrin@toshiba.co.jp> <1453444200-8604-2-git-send-email-daniel.sangorrin@toshiba.co.jp> <20160122104837.GA14440@pc.thejh.net>
Reply-To: kernel-hardening@lists.openwall.com
Mime-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <kernel-hardening-return-2463-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <20160122104837.GA14440@pc.thejh.net>
Content-Language: ja
To: 'Jann Horn' <jann@thejh.net>
Cc: keescook@chromium.org, luto@amacapital.net, wad@chromium.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, kernel-hardening@lists.openwall.com, 'Alexei Starovoitov' <alexei.starovoitov@gmail.com>'Andy Lutomirski' <luto@amacapital.net>, 'Paul Moore' <paul@paul-moore.com>
List-Id: linux-api@vger.kernel.org

Hi,

Jann, Andy, Alexei, Kees and Paul: thanks a lot for your comments on my RFC!!.

There were a few important points that I didn't mention but are critical to understand
what I was trying to do.  The focus of the patch was on protecting "real-time 
embedded IoT devices" such as a PLC (programmable logic controller) inside a factory 
assembly line . 

They have a few important properties that I took into consideration:

    - They often rely on firewall technology, and are not updated for many 
       years (~20 years). For that reason, I think that a white-list approach (define 
       the correct behaviour) seems suitable. Note also that the typical problem
       of white list approaches, false-positives, is unlikely to occur because they
       are very deterministic systems.

    - No asynchronous signal handlers: real-time applications need deterministic
       response times. For that reason, signals are handled synchronously typically
       by using 'sigtimedwait' on a separate thread.

    - Initialization vs cycle: real-time applications usually have an initialization phase
       where memory and stack are locked into RAM and threads are created. After
       the initialization phase, threads typically loop through periodic cycles and 
       perform their tasks. The important point here is that once the initialization 
       is done we can ban any further calls to 'clone', 'execve', 'mprotect' and the like. 
       This can be done already by installing an extra filter. For the cyclic phase, my
       patch would allow enforcing the order of the system calls inside the cycles.
       (e.g.: read sensor, send a message, and write to an actuator). Despite the
       fact that the attacker cannot call 'clone' anymore, he could try to alter the 
       control of an external actuator (e.g. a motor) by using the 'ioctl' system call
       for example.

    - Mimicry: as I mentioned in the cover letter (and Jann showed with
       his ROP attack) if the attacker is able to emulate the system call's order
       (plus its arguments  and the address from which the call was made)
       this patch can be bypassed. However, note that this is not easy for several
       reasons:
               + the attacker may need a long stack to mimic all the system calls and their
                   arguments.
               + the stealthy attacker must make sure the real-time application does not
                   crash, miss any of its deadlines or cause deadline misses in other apps
                   [Note] Real-time application binaries are usually closed source so 
                    this might require quite a bit of effort.
               + randomized system calls: applications could randomly activate dummy 
                   system calls each time they are instantiated (and adjust their BPF filter,
                   which should later be zeroed).  In this case, the attacker (or virus) 
                   would need to figure out which dummy system calls have to
                   be mimicked and prepare a stack accordingly. This seems challenging.
                   [Note] under a brute force attack, the application may just raise an alarm,
                    activate a redundant node (not connected to the network) and 
                    commit digital suicide :).

About the ABI, by all means I don't want to break it. If putting the field at
the end does not break it, as Alexei mentioned, I can change it. Also I would
be glad to review the SECCOMP_FILTER_FLAG_TSYNC flag mentioned by Jann
in case there is any interest.

However, I'll understand the NACK if you think that the maintenance is not worth it
as Andy mentioned; that it can be bypassed under certain conditions; or the fact 
that it focuses on a particular type of systems. I will keep reading the
messages in the kernel-hardening list and see if I find another topic to
contribute :).

Thanks a lot for your consideration and comments,
Daniel

From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH] procfd_signal.2: document procfd_signal syscall
Date: Thu, 29 Nov 2018 10:12:05 +1300
Message-ID: <E81EDAAC-F9E3-4D3A-AEE8-09E266D7FEDB@brauner.io>
References: <20181119103241.5229-1-christian@brauner.io> <20181119103241.5229-4-christian@brauner.io> <87in0g7waf.fsf@oldenburg.str.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87in0g7waf.fsf@oldenburg.str.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Weimer <fweimer@redhat.com>
Cc: ebiederm@xmission.com, linux-kernel@vger.kernel.org, serge@hallyn.com, jannh@google.com, luto@kernel.org, akpm@linux-foundation.org, oleg@redhat.com, cyphar@cyphar.com, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, dancol@google.com, timmurray@google.com, linux-man@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On November 29, 2018 9:59:52 AM GMT+13:00, Florian Weimer <fweimer@redhat=
=2Ecom> wrote:
>* Christian Brauner:
>
>> +=2E\" Copyright (C) 2018 Christian Brauner <christian@brauner=2Eio>
>
>The text seems to be largely derived from rt_sigqueueinfo, so I'm not
>sure if this appropriate here=2E
>
>> +the null signal (0) can be used to check if a process with a given
>> +PID exists=2E
>
>What does this mean if hte process is identified by file descriptor?
>
>> +=2EPP
>> +The optional
>> +=2EI info
>> +argument specifies the data to accompany the signal=2E
>> +This argument is a pointer to a structure of type
>> +=2EIR siginfo_t ,
>> +described in
>> +=2EBR sigaction (2)
>> +(and defined by including
>> +=2EIR <sigaction=2Eh> )=2E
>> +The caller should set the following fields in this structure:
>> +=2ETP
>> +=2EI si_code
>> +This must be one of the
>> +=2EB SI_*
>> +codes in the Linux kernel source file
>> +=2EIR include/asm-generic/siginfo=2Eh ,
>> +with the restriction that the code must be negative
>> +(i=2Ee=2E, cannot be
>> +=2EBR SI_USER ,
>> +which is used by the kernel to indicate a signal sent by
>> +=2EBR kill (2))
>> +and cannot (since Linux 2=2E6=2E39) be
>
>Obsolete reference in this context=2E
>
>> +=2ETP
>> +=2EB ESRCH
>> +The process or process group does not exist=2E
>> +Note that an existing process might be a zombie,
>> +a process that has terminated execution, but
>> +has not yet been
>> +=2EBR wait (2)ed
>> +for=2E
>
>Again: What does this mean if the process identified by a descriptor?
>Does a process in zombie state exist in this sense or not?
>
>Thanks,
>Florian

Updating the document is on my Todo=2E
Florian, can you take a look at the actual patch too, please?

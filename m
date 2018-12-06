From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH v4] signal: add taskfd_send_signal() syscall
Date: Thu, 06 Dec 2018 08:46:57 -0600
Message-ID: <87bm5yiufy.fsf@xmission.com>
References: <20181206121858.12215-1-christian@brauner.io>
        <87h8fq7s84.fsf@oldenburg2.str.redhat.com>
        <b0e946bcac12358841c9a99017da819b00794d9c.camel@bitron.ch>
        <87pnue6bp2.fsf@oldenburg2.str.redhat.com>
        <87efaun587.fsf@xmission.com>
        <877egm6a7v.fsf@oldenburg2.str.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <877egm6a7v.fsf@oldenburg2.str.redhat.com> (Florian Weimer's
        message of "Thu, 06 Dec 2018 14:44:36 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Weimer <fweimer@redhat.com>
Cc: =?utf-8?Q?J=C3=BCrg?= Billeter <j@bitron.ch>, Christian Brauner <christian@brauner.io>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, luto@kernel.org, arnd@arndb.de, serge@hallyn.com, jannh@google.com, akpm@linux-foundation.org, oleg@redhat.com, cyphar@cyphar.com, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, dancol@google.com, timmurray@google.com, linux-man@vger.kernel.org, keescook@chromium.org, tglx@linutronix.de, x86@kernel.org
List-Id: linux-api@vger.kernel.org

Florian Weimer <fweimer@redhat.com> writes:

> * Eric W. Biederman:
>
>> Floriam are you seeing a problem with this behavior or the way Christian
>> was describing it?
>
> My hope is that you could use taskfd_send_signal one day to send a
> signal to a process which you *known* (based on how you've written your
> application) should be running and not in a zombie state, and get back
> an error if it has exited.
>
> If you get this error, only then you wait on the process, using the file
> descriptor you have, and run some recovery code.
>
> Wouldn't that be a reasonable approach once we've got task descriptors?

Getting an error back if the target was a zombie does seem reasonable,
as in principle it is an easy thing to notice, and post zombie once the
process has been reaped we definitely get an error back.

I also agree that it sounds like an extension, as changing the default
would violate the princile of least surprise.

Eric

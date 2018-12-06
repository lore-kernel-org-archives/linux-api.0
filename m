From: Florian Weimer <fweimer@redhat.com>
Subject: Re: [PATCH v4] signal: add taskfd_send_signal() syscall
Date: Thu, 06 Dec 2018 13:30:19 +0100
Message-ID: <87h8fq7s84.fsf@oldenburg2.str.redhat.com>
References: <20181206121858.12215-1-christian@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181206121858.12215-1-christian@brauner.io> (Christian
        Brauner's message of "Thu, 6 Dec 2018 13:18:58 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, luto@kernel.org, arnd@arndb.de, ebiederm@xmission.com, serge@hallyn.com, jannh@google.com, akpm@linux-foundation.org, oleg@redhat.com, cyphar@cyphar.com, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, dancol@google.com, timmurray@google.com, linux-man@vger.kernel.org, keescook@chromium.org, tglx@linutronix.de, x86@kernel.org
List-Id: linux-api@vger.kernel.org

* Christian Brauner:

> /* zombies */
> Zombies can be signaled just as any other process. No special error will be
> reported since a zombie state is an unreliable state (cf. [3]).

I still disagree with this analysis.  If I know that the target process
is still alive, and it is not, this is a persistent error condition
which can be reliably reported.  Given that someone might send SIGKILL
to the process behind my back, detecting this error condition could be
useful.

Rest looks good to me (with the usual caveats).

Thanks,
Florian

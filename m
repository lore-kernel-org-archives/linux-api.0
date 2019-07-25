From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH 2/5] pidfd: add pidfd_wait()
Date: Thu, 25 Jul 2019 09:34:28 -0500
Message-ID: <87zhl2uqrv.fsf@xmission.com>
References: <20190724144651.28272-1-christian@brauner.io>
        <20190724144651.28272-3-christian@brauner.io>
        <CAHk-=whZPKzbPQftNGFB=iaSZGTSXNkhUASWF2V53MwB+A4zAQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHk-=whZPKzbPQftNGFB=iaSZGTSXNkhUASWF2V53MwB+A4zAQ@mail.gmail.com>
        (Linus Torvalds's message of "Wed, 24 Jul 2019 10:45:38 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christian Brauner <christian@brauner.io>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Kees Cook <keescook@chromium.org>, Joel Fernandes <joel@joelfernandes.org>, Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>, David Howells <dhowells@redhat.com>, Jann Horn <jannh@google.com>, Andrew Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Aleksa Sarai <cyphar@cyphar.com>, Al Viro <viro@zeniv.linux.org.uk>, Android Kernel Team <kernel-team@android.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Wed, Jul 24, 2019 at 7:47 AM Christian Brauner <christian@brauner.io> wrote:
>>
>> This adds the pidfd_wait() syscall.
>
> I despise this patch.
>
> Why can't this just be a new P_PIDFD flag, and then use
> "waitid(P_PIDFD, pidfd, ...);"
>
> Yes, yes, yes, I realize that "pidfd" is of type "int", and waitid()
> takes an argument of type pid_t, but it's the same type in the end,
> and it does seem like the whole *point* of "waitid()" is that
> "idtype_t idtype" which tells you what kind of ID you're passing it.

Just to emphasize this point.

The posix declaration of waitid is:
>int waitid(idtype_t idtype, id_t id, siginfo_t *infop, int options);

Where id_t is defined as:
> id_t - Used as a general identifier; can be used to contain at least a pid_t, uid_t, or gid_t.

And the BSDs at least have defined P_UID and P_GID.  So that flexibility
has been used.

So it looks entirely reasonable to have P_PIDFD that just waits for a
specified child.

Eric

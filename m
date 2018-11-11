From: Florian Weimer <fweimer@redhat.com>
Subject: Re: Official Linux system wrapper library?
Date: Sun, 11 Nov 2018 12:02:04 +0100
Message-ID: <878t1zx4gj.fsf@oldenburg.str.redhat.com>
References: <CAKOZuesB4R=dCz4merWQN0FSCGrXmOgUUr4ienSbStBJguNv8g@mail.gmail.com>
        <bbc12da5-830e-99a7-95e3-d9da42947dc9@gmail.com>
        <20181111081725.GA30248@1wt.eu>
        <3664a508-ca74-4ff0-39a6-34543194a24e@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3664a508-ca74-4ff0-39a6-34543194a24e@gmail.com> (Michael
        Kerrisk's message of "Sun, 11 Nov 2018 11:53:54 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Willy Tarreau <w@1wt.eu>, Daniel Colascione <dancol@google.com>, linux-kernel <linux-kernel@vger.kernel.org>, Joel Fernandes <joelaf@google.com>, Linux API <linux-api@vger.kernel.org>, Vlastimil Babka <vbabka@suse.cz>, Carlos O'Donell <carlos@redhat.com>, "libc-alpha@sourceware.org" <libc-alpha@sourceware.org>
List-Id: linux-api@vger.kernel.org

* Michael Kerrisk:

> I'm not sure I'd view the glibc position quite so harshly (although 
> it is disappointing to me that bug 6399 remains open). I think they
> are simply short of people to work on this task. There was a lengthy
> period where no syscall wrappers were being added (pretty much from
> 2.16 to 2.24, as far as I can tell), but that has changed.

People may have disappeared from glibc development who have objected to
gettid.  I thought this was the case with strlcpy/strlcat, but it was
not.

At present, it takes one semi-active glibc contributor to block addition
of a system call.  The process to override a sustained objection has
never been used successfully, and it is a lot of work to get it even
started.

Thanks,
Florian

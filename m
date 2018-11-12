From: Joseph Myers <joseph@codesourcery.com>
Subject: Re: Official Linux system wrapper library?
Date: Mon, 12 Nov 2018 16:43:26 +0000
Message-ID: <alpine.DEB.2.21.1811121641040.6607@digraph.polyomino.org.uk>
References: <CAKOZuesB4R=dCz4merWQN0FSCGrXmOgUUr4ienSbStBJguNv8g@mail.gmail.com> <bbc12da5-830e-99a7-95e3-d9da42947dc9@gmail.com> <20181111081725.GA30248@1wt.eu> <3664a508-ca74-4ff0-39a6-34543194a24e@gmail.com> <878t1zx4gj.fsf@oldenburg.str.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <878t1zx4gj.fsf@oldenburg.str.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Weimer <fweimer@redhat.com>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, Willy Tarreau <w@1wt.eu>, Daniel Colascione <dancol@google.com>, linux-kernel <linux-kernel@vger.kernel.org>, Joel Fernandes <joelaf@google.com>, Linux API <linux-api@vger.kernel.org>, Vlastimil Babka <vbabka@suse.cz>, Carlos O'Donell <carlos@redhat.com>, "libc-alpha@sourceware.org" <libc-alpha@sourceware.org>
List-Id: linux-api@vger.kernel.org

On Sun, 11 Nov 2018, Florian Weimer wrote:

> People may have disappeared from glibc development who have objected to
> gettid.  I thought this was the case with strlcpy/strlcat, but it was
> not.

Well, I know of two main people who were objecting to the notion of adding 
bindings for all non-obsolescent syscalls, Linux-specific if not suitable 
for adding to the OS-independent GNU API, and neither seems to have posted 
in the past year.

> At present, it takes one semi-active glibc contributor to block addition
> of a system call.  The process to override a sustained objection has
> never been used successfully, and it is a lot of work to get it even
> started.

We don't have such a process.  (I've suggested, e.g. in conversation with 
Carlos at the Cauldron, that we should have something involving a 
supermajority vote of the GNU maintainers for glibc in cases where we're 
unable to reach a consensus in the community as a whole.)

-- 
Joseph S. Myers
joseph@codesourcery.com

From: Carlos O'Donell <carlos@redhat.com>
Subject: Re: Official Linux system wrapper library?
Date: Tue, 13 Nov 2018 10:15:39 -0500
Message-ID: <85ce01c3-0704-b915-e591-437a051d371c@redhat.com>
References: <CAKOZuesB4R=dCz4merWQN0FSCGrXmOgUUr4ienSbStBJguNv8g@mail.gmail.com>
 <bbc12da5-830e-99a7-95e3-d9da42947dc9@gmail.com>
 <20181111081725.GA30248@1wt.eu>
 <3664a508-ca74-4ff0-39a6-34543194a24e@gmail.com>
 <878t1zx4gj.fsf@oldenburg.str.redhat.com>
 <alpine.DEB.2.21.1811121641040.6607@digraph.polyomino.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.21.1811121641040.6607@digraph.polyomino.org.uk>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Joseph Myers <joseph@codesourcery.com>, Florian Weimer <fweimer@redhat.com>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, Willy Tarreau <w@1wt.eu>, Daniel Colascione <dancol@google.com>, linux-kernel <linux-kernel@vger.kernel.org>, Joel Fernandes <joelaf@google.com>, Linux API <linux-api@vger.kernel.org>, Vlastimil Babka <vbabka@suse.cz>, "libc-alpha@sourceware.org" <libc-alpha@sourceware.org>
List-Id: linux-api@vger.kernel.org

On 11/12/18 11:43 AM, Joseph Myers wrote:
> On Sun, 11 Nov 2018, Florian Weimer wrote:
> 
>> People may have disappeared from glibc development who have objected to
>> gettid.  I thought this was the case with strlcpy/strlcat, but it was
>> not.
> 
> Well, I know of two main people who were objecting to the notion of adding 
> bindings for all non-obsolescent syscalls, Linux-specific if not suitable 
> for adding to the OS-independent GNU API, and neither seems to have posted 
> in the past year.
> 
>> At present, it takes one semi-active glibc contributor to block addition
>> of a system call.  The process to override a sustained objection has
>> never been used successfully, and it is a lot of work to get it even
>> started.
> 
> We don't have such a process.  (I've suggested, e.g. in conversation with 
> Carlos at the Cauldron, that we should have something involving a 
> supermajority vote of the GNU maintainers for glibc in cases where we're 
> unable to reach a consensus in the community as a whole.)
 
... and I need a good excuse to propose such a process :-)

-- 
Cheers,
Carlos.

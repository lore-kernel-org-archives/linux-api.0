From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH 04/13] Always expose MAP_UNINITIALIZED to userspace
Date: Tue, 15 Sep 2015 03:23:58 +0300
Message-ID: <20150915002358.GA12618@node.dhcp.inet.fi>
References: <1441832902-28993-1-git-send-email-palmer@dabbelt.com>
 <1442271047-4908-1-git-send-email-palmer@dabbelt.com>
 <1442271047-4908-5-git-send-email-palmer@dabbelt.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1442271047-4908-5-git-send-email-palmer@dabbelt.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Palmer Dabbelt <palmer@dabbelt.com>
Cc: arnd@arndb.de, dhowells@redhat.com, viro@zeniv.linux.org.uk, ast@plumgrid.com, aishchuk@linux.vnet.ibm.com, aarcange@redhat.com, akpm@linux-foundation.org, luto@kernel.org, acme@kernel.org, bhe@redhat.com, 3chas3@gmail.com, chris@zankel.net, dave@sr71.net, dyoung@redhat.com, drysdale@google.com, davem@davemloft.net, ebiederm@xmission.com, geoff@infradead.org, gregkh@linuxfoundation.org, hpa@zytor.com, mingo@kernel.org, iulia.manda21@gmail.com, plagnioj@jcrosoft.com, jikos@kernel.org, josh@joshtriplett.org, kexec@lists.infradead.org, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-xtensa@linux-xtensa.org, mathieu.desnoyers@efficios.com, jcmvbkbc@gmail.com, paulmck@linux.vnet.ibm.com, a.p.zijlstra@chello.nl, tglx@linutronix.de, tomi.valkeinen@ti.com, vgoyal@redhat.com, x86@kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, Sep 14, 2015 at 03:50:38PM -0700, Palmer Dabbelt wrote:
> This used to be hidden behind CONFIG_MMAP_ALLOW_UNINITIALIZED, so
> userspace wouldn't actually ever see it be non-zero.  While I could
> have kept hiding it, the man pages seem to indicate that
> MAP_UNINITIALIZED should be visible:
> 
>   mmap(2)
>   MAP_UNINITIALIZED (since Linux 2.6.33)
>     Don't clear anonymous pages.  This flag is intended to improve
>     performance on embedded devices.  This flag is honored only if the
>     kernel was configured with the CONFIG_MMAP_ALLOW_UNINITIALIZED
>     option.  Because of the security implications, that option is
>     normally enabled only on embedded devices (i.e., devices where one
>     has complete control of the contents of user memory).
> 
> and since the only time it shows up in my /usr/include is in this
> header I believe this should have been visible to userspace (as
> non-zero, which wouldn't do anything when or'd into the flags) all
> along.

Are you sure about "wouldn't do anything"?
Suspiciously, 0x4000000 is also (1 << MAP_HUGE_SHIFT). I'm not sure if any
architecture has order-1 huge pages, but still looks like we have conflict
here.

I think it's harmful to expose non-zero MAP_UNINITIALIZED to system which
potentially can handle multiple users. Or non-trivial user space in
general.

Should we leave it at least under '#ifndef CONFIG_MMU'? I don't think it's
possible to have single ABI for MMU and MMU-less systems anyway. And we
can avoid conflict with MAP_HUGE_SHIFT this way.

P.S. MAP_UNINITIALIZED itself looks very broken to me. I probably need dig
mailing list on why it was allowed. 
But that's other topic.

-- 
 Kirill A. Shutemov

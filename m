From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH v3] mm: add mremap flag for preserving the old mapping
Date: Mon, 29 Sep 2014 22:53:18 -0700
Message-ID: <CALCETrX6D7X7zm3qCn8kaBtYHCQvdR06LAAwzBA=1GteHAaLKA@mail.gmail.com>
References: <1412052900-1722-1-git-send-email-danielmicay@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1412052900-1722-1-git-send-email-danielmicay-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Daniel Micay <danielmicay-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, jasone-Z38pQHDqNGNl57MIdRCFDg@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, Sep 29, 2014 at 9:55 PM, Daniel Micay <danielmicay-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> This introduces the MREMAP_RETAIN flag for preserving the source mapping
> when MREMAP_MAYMOVE moves the pages to a new destination. Accesses to
> the source location will fault and cause fresh pages to be mapped in.
>
> For consistency, the old_len >= new_len case could decommit the pages
> instead of unmapping. However, userspace can accomplish the same thing
> via madvise and a coherent definition of the flag is possible without
> the extra complexity.

IMO this needs very clear documentation of exactly what it does.

Does it preserve the contents of the source pages?  (If so, why?
Aren't you wasting a bunch of time on page faults and possibly
unnecessary COWs?)

Does it work on file mappings?  Can it extend file mappings while it moves them?

If you MREMAP_RETAIN a partially COWed private mapping, what happens?

Does it work on special mappings?  If so, please prevent it from doing
so.  mremapping x86's vdso is a thing, and duplicating x86's vdso
should not become a thing, because x86_32 in particular will become
extremely confused.

--Andy

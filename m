From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH v4 1/2] capabilities: Ambient capabilities
Date: Wed, 15 Jul 2015 10:09:49 -0700
Message-ID: <CALCETrWMBZ0p7P1FvtrYp5ChJXvvRzy0JpjS8KwUUa5m9gqgQA@mail.gmail.com>
References: <cover.1436903028.git.luto@kernel.org> <9f660ee708e58892bfa7012b6b9c840298e24544.1436903028.git.luto@kernel.org>
 <alpine.LRH.2.11.1507152033420.8351@namei.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LRH.2.11.1507152033420.8351-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Morris <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>
Cc: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Ted Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, "Andrew G. Morgan" <morgan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Aaron Jones <aaronmdjones-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Markku Savela <msa-kXoF896ld44xHbG02/KK1g@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Jul 15, 2015 at 4:13 AM, James Morris <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org> wrote:
> On Tue, 14 Jul 2015, Andy Lutomirski wrote:
>
>> ===== The proposed change =====
>>
>> This patch adds a fifth capability mask called the ambient mask
>> (pA).  pA does what most people expect pI to do.
>>
>
> This looks good, and I think it will lead to better overall security
> because people will find capabilities easier to use for real-world
> scenarios.
>
> Has it had enough security review?  This is a significant new behavior
> being added to a widely enabled security module.
>

I've reviewed it, as have Kees and Serge.  Of course, I wrote it, so
my review should be taken with many grains of salt.

I'll review it again between now and 4.3.  All of my security thought
cycles are currently taken up by a really nasty bug that dwarfs and
problems this code could possibly introduce :)

--Andy

>
>
> - James
> --
> James Morris
> <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>
>



-- 
Andy Lutomirski
AMA Capital Management, LLC

From: Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [kernel-hardening] Re: [PATCH v3 1/2] modules:capabilities:
 automatic module loading restriction
Date: Thu, 20 Apr 2017 22:39:21 +0200
Message-ID: <CAEiveUdFL53XyQpacmN6f8F28M0bLQDcetpRXJjrJ10vDmQi8Q@mail.gmail.com>
References: <1492640420-27345-1-git-send-email-tixxdz@gmail.com>
 <1492640420-27345-2-git-send-email-tixxdz@gmail.com> <1492654942.31767.21.camel@decadent.org.uk>
 <CAEiveUdS=GbyxDVeNFrjTmhvQB-a6UgrJXcGY=BYJLu+3z0x_Q@mail.gmail.com> <1492700543.31767.23.camel@decadent.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1492700543.31767.23.camel-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
Cc: Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org, LSM List <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dongsu Park <dpark-VwIFZPTo/vqsTnJN9+BGXg@public.gmane.org>, Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Jessica Yu <jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, Arnaldo Carvalho de Melo <acme-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mauro Carvalho Chehab <mcheh>
List-Id: linux-api@vger.kernel.org

On Thu, Apr 20, 2017 at 5:02 PM, Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org> wrote:
> On Thu, 2017-04-20 at 14:44 +0200, Djalal Harouni wrote:
>> > On Thu, Apr 20, 2017 at 4:22 AM, Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org> wrote:
>> > On Thu, 2017-04-20 at 00:20 +0200, Djalal Harouni wrote:
>> > [...]
[...]
>> modules_disabled is too restrictive and once set it can't be changed,
>> maybe that's why not all users use it.
>>
>> With modules_disabled=0 and modules_autoload=2
> [...]
>
> Hmm, OK.  How about naming this modules_autoload_mode, then, so that
> it's obviously not a boolean?

Yes that's fine by me, kees already suggested to rename it to
"modules_autoload" I can change it to that if it's the best
suggestion!

Thanks!

> Ben.
>
> --
> Ben Hutchings
> It is easier to change the specification to fit the program than vice
> versa.
>



-- 
tixxdz

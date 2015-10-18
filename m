From: Tobias Markus <tobias@miglix.eu>
Subject: Re: [PATCH] userns/capability: Add user namespace capability
Date: Sun, 18 Oct 2015 22:13:58 +0200
Message-ID: <5623FD86.2030609@miglix.eu>
References: <5622700C.9090107@miglix.eu>
 <CAFLxGvzJONWTbpD8GFfDWDQiPxONrFaRAuXonXXUWaR1pcTUgw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAFLxGvzJONWTbpD8GFfDWDQiPxONrFaRAuXonXXUWaR1pcTUgw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Richard Weinberger <richard.weinberger@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Al Viro <viro@zeniv.linux.org.uk>, Serge Hallyn <serge.hallyn@canonical.com>, Andrew Morton <akpm@linuxfoundation.org>, Andy Lutomirski <luto@amacapital.net>, Christoph Lameter <cl@linux.com>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, LSM <linux-security-module@vger.kernel.org>, "open list:ABI/API" <linux-api@vger.kernel.org>, linux-man <linux-man@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 17.10.2015 22:17, Richard Weinberger wrote:
> On Sat, Oct 17, 2015 at 5:58 PM, Tobias Markus <tobias@miglix.eu> wrote:
>> One question remains though: Does this break userspace executables that
>> expect being able to create user namespaces without priviledge? Since
>> creating user namespaces without CAP_SYS_ADMIN was not possible before
>> Linux 3.8, programs should already expect a potential EPERM upon calling
>> clone. Since creating a user namespace without CAP_SYS_USER_NS would
>> also cause EPERM, we should be on the safe side.
> 
> In case of doubt, yes it will break existing software.
> Hiding user namespaces behind CAP_SYS_USER_NS will not magically
> make them secure.
> 
The goal is not to make user namespaces secure, but to limit access to
them somewhat in order to reduce the potential attack surface.
Please see my reply to Serge for further details.

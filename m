From: Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH v2 0/7] Smack namespace
Date: Wed, 27 May 2015 06:05:57 -0700
Message-ID: <5565C135.7020504@schaufler-ca.com>
References: <1432209222-8479-1-git-send-email-l.pawelczyk@samsung.com> <1432557162-19123-1-git-send-email-l.pawelczyk@samsung.com> <55651823.10304@schaufler-ca.com> <1432718944.1784.1.camel@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1432718944.1784.1.camel@samsung.com>
Sender: linux-security-module-owner@vger.kernel.org
To: Lukasz Pawelczyk <l.pawelczyk@samsung.com>
Cc: "David S. Miller" <davem@davemloft.net>, "Eric W. Biederman" <ebiederm@xmission.com>, "Kirill A. Shutemov" <kirill@shutemov.name>, "Serge E. Hallyn" <serge@hallyn.com>, Al Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@amacapital.net>, David Howells <dhowells@redhat.com>, Fabian Frederick <fabf@skynet.be>, Greg KH <gregkh@linuxfoundation.org>, James Morris <james.l.morris@oracle.com>, Jeff Layton <jlayton@primarydata.com>, Jingoo Han <jg1.han@samsung.com>, Joe Perches <joe@perches.com>, John Johansen <john.johansen@canonical.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Miklos Szeredi <miklos@szeredi.hu>, Oleg Nesterov <oleg@redhat.com>, Paul Moore <paul@paul-moore.com>, Stephen Smalley <sds@tycho.>
List-Id: linux-api@vger.kernel.org

On 5/27/2015 2:29 AM, Lukasz Pawelczyk wrote:
> On wto, 2015-05-26 at 18:04 -0700, Casey Schaufler wrote:
>> On 5/25/2015 5:32 AM, Lukasz Pawelczyk wrote:
>>> Hello,
>>>
>>> Some time ago I sent a Smack namespace documentation and a preliminary
>>> LSM namespace for RFC. I've been suggested that there shouldn't be a
>>> separate LSM namespace and that it should live within user namespace.
>>> And this version does. This is a complete set of patches required for
>>> Smack namespace.
>>>
>>> This was designed with a collaboration of Smack maintainer Casey
>>> Schaufler.
>>>
>> I have reviewed these patches (again!) and don't have
>> any issues. I see that Mr. Smalley has some insightful
>> suggestions, and once those are addressed I think that
>> we should be lined up to sell it to the infrastructure.
>
> Thank you.
>
> Can I add
> Reviewed-by: Casey Schaufler <casey@schaufler-ca.com>
>
> to those 7 the patches?

Yes, but please be sure to address the issues raised by Stephen and Eric.


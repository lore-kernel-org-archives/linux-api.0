From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mickael.salaun@ssi.gouv.fr>
Subject: Re: [RFC PATCH v1 0/5] Add support for O_MAYEXEC
Date: Thu, 13 Dec 2018 15:57:15 +0100
Message-ID: <21824ed9-0fe4-85dd-bdd2-d4426e97233d@ssi.gouv.fr>
References: <20181212081712.32347-1-mic@digikod.net>
 <alpine.LRH.2.21.1812130642250.29507@namei.org>
 <87lg4upkpv.fsf@oldenburg2.str.redhat.com>
 <alpine.LRH.2.21.1812131039400.7600@namei.org>
 <87ftv2ovp8.fsf@oldenburg2.str.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87ftv2ovp8.fsf@oldenburg2.str.redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Weimer <fweimer@redhat.com>, James Morris <jmorris@namei.org>
Cc: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>, linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Matthew Garrett <mjg59@google.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Mimi Zohar <zohar@linux.ibm.com>, =?UTF-8?Q?Philippe_Tr=c3=a9buchet?= <philippe.trebuchet@ssi.gouv.fr>, Shuah Khan <shuah@kernel.org>, Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>, Vincent Strubel <vincent.strubel@ssi.gouv.fr>, Yves-Alexis Perez <yves-alexis.perez@ssi.gouv.fr>, kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-api@vger.kernel.org


On 13/12/2018 06:13, Florian Weimer wrote:
> * James Morris:
> 
>> On Wed, 12 Dec 2018, Florian Weimer wrote:
>>
>>> * James Morris:
>>>
>>>> If you're depending on the script interpreter to flag that the user may 
>>>> execute code, this seems to be equivalent in security terms to depending 
>>>> on the user.  e.g. what if the user uses ptrace and clears O_MAYEXEC?

This security mechanism makes sense in an hardened system where the user
is not allowed to import and execute new file (write xor execute
policy). This can be enforced with appropriate mount points a more
advanced access control policy.

>>>
>>> The argument I've heard is this: Using ptrace (and adding the +x
>>> attribute) are auditable events.
>>
>> I guess you could also preload a modified libc which strips the flag.
> 
> My understanding is that this new libc would have to come somewhere, and
> making it executable would be an auditable even as well.

Auditing is a possible use case as well, but the W^X idea is to deny use
of libraries which are not in an executable mount point, i.e. only
execute trusted code.

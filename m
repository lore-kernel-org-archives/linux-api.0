From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: [REPOST][RFC][PATCH] sysctl: Remove the sysctl system call
Date: Tue, 8 Oct 2019 12:30:35 +0200
Message-ID: <4c3e4883-706e-fd1b-4f4f-0653eabeb027@gmail.com>
References: <8736gcjosv.fsf@x220.int.ebiederm.org>
 <201910011140.EA0181F13@keescook> <87y2y271ws.fsf@mid.deneb.enyo.de>
 <87tv8pftjj.fsf_-_@x220.int.ebiederm.org> <201910031404.C30A0F16@keescook>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201910031404.C30A0F16@keescook>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>, "Eric W. Biederman" <ebiederm@xmission.com>
Cc: mtk.manpages@gmail.com, Florian Weimer <fw@deneb.enyo.de>, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Jann Horn <jannh@google.com>, Arnd Bergmann <arnd@arndb.de>, Helge Deller <deller@gmx.de>
List-Id: linux-api@vger.kernel.org

On 10/3/19 11:05 PM, Kees Cook wrote:
> On Thu, Oct 03, 2019 at 03:44:32PM -0500, Eric W. Biederman wrote:
>>
>> This system call has been deprecated almost since it was introduced, and none
>> of the common distributions enable it.  The only indication that I can find that
>> anyone might care is that a few of the defconfigs in the kernel enable it.  However
>> that is a small fractions of the defconfigs so I suspect it just a lack of care
>> rather than a reflection of software using the the sysctl system call.
>>
>> As there appear to be no users of the sysctl system call, remove the
>> code so that the proc filesystem can be simplified.
> 
> nitpick: line lengths near 80 characters
> 
>> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> 
> But, yes, I would love to see this gone. :)
> 
> Reviewed-by: Kees Cook <keescook@chromium.org>

And for the record, the manual page has since 2007 documented that 
this system call is likely to go away in the future.

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/

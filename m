From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: Re: [GIT PULL] kselftest-3.19-rc1
Date: Mon, 15 Dec 2014 07:04:56 -0700
Message-ID: <548EEA88.2060206@osg.samsung.com>
References: <548750AD.6090201@osg.samsung.com> <CA+55aFx2DSXuikfd-RyEN3V+OaLSYhWub92=NJsNXGUhVnKKFQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+55aFx2DSXuikfd-RyEN3V+OaLSYhWub92=NJsNXGUhVnKKFQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Shuah Khan <shuah.kh-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 12/13/2014 02:32 PM, Linus Torvalds wrote:
> On Tue, Dec 9, 2014 at 11:42 AM, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org> wrote:
>>
>> Please pull the following kselftest updates for 3.19-rc1. Details
>> in the singed tag:
> 
> Gaah. Why do you do this to me?
> 
>> git-OoYKEaZ2EDaWaY/ihj7yzEB+6BGkLq7r@public.gmane.org:/pub/scm/linux/kernel/git/shuah/linux-kselftest
>> fixes
> 
> That's the wrong format, but it's also the wrong branch name.
> 
> What it *should* have said is
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/shuah/linux-kselftest
> tags/kselftest-3.19-rc1
> 
> which is actually publicly accessible, and has the right tag name.
> 
> EXCEPT THAT'S WRONG TOO! The actual kselftest-3.19-rc1 tag doesn't
> point to the commits in fixes at all! It points to commit
> 0df1f2487d2f, which is my 3.18-rc3 commit.
> 
> Please fix your script/workflow. I'm not pulling this mess.
> 

Sorry. I thought I have the workflow right. Doesn't look like I do.
I will fix it and send you another.

-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Samsung Open Source Group
Samsung Research America (Silicon Valley)
shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org | (970) 217-8978

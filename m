From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH RFC] user-namespaced file capabilities - now with even
 more magic
Date: Fri, 25 Nov 2016 21:43:31 +0100
Message-ID: <0d1a7bc4-2e9c-73ba-11fb-f233e790b3a6@gmail.com>
References: <20161119151739.GA16398@mail.hallyn.com>
 <8acb3b53-d5eb-0524-2c57-31fcb7e736d9@gmail.com>
 <20161124225246.GA16648@mail.hallyn.com>
 <d2160ca5-12e5-0be7-ade7-c4ee63e1df32@gmail.com>
 <20161125175009.GA326@mail.hallyn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161125175009.GA326-7LNsyQBKDXoIagZqoN9o3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 11/25/2016 06:50 PM, Serge E. Hallyn wrote:
> On Fri, Nov 25, 2016 at 09:33:50AM +0100, Michael Kerrisk (man-pages) wrote:
>> Hi Serge,
>>
>> On 11/24/2016 11:52 PM, Serge E. Hallyn wrote:
>>> Quoting Michael Kerrisk (man-pages) (mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org):
>>
>> [...]
>>
>>>> Could we have a man-pages patch for this feature? Presumably for 
>>>> user_namespaces(7) or capabilities(7).
>>>
>>> capabilities.7 doesn't actually mention anything about user namespaces
>>> right now.  
>>
>> True. There's really just this:
>>
>>    Interaction with user namespaces
>>        For a discussion of  the  interaction  of  capabilities  and  user
>>        namespaces, see user_namespaces(7).
>>
>>> I'll come up with a patch for both I think.  Do you have a
>>> deadline for a new release coming up?
>>
>> No deadlines as such. The last couple of years, as a sort of 
>> experiment, I've fallen into the same release cycle as the kernel
>> (typically making a release in the week or so after the kernel release),
>> and I am even using a similar numbering scheme. Ideally, the man-pages
>> patch would go into the release that corresponds to the kernel release
>> that makes the change.
> 
> Cool - I'll write something up in the next few weeks.

Obviously, the sooner you write it, the sooner others may read--and
perhaps test--it.

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/

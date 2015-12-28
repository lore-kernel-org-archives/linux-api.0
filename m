From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: Re: [PATCH RFC] [media] Postpone the addition of MEDIA_IOC_G_TOPOLOGY
Date: Mon, 28 Dec 2015 09:05:34 -0700
Message-ID: <56815DCE.6040304@osg.samsung.com>
References: <d029047c76d6d3e5e6a531080ede83f6e063f7db.1451311244.git.mchehab@osg.samsung.com>
 <5681572F.601@osg.samsung.com> <20151228154429.GA27560@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151228154429.GA27560-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Linux Media Mailing List <linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mauro Carvalho Chehab <mchehab-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hans Verkuil <hverkuil-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org>, Laurent Pinchart <laurent.pinchart-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org>, Javier Martinez Canillas <javier-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Sakari Ailus <sakari.ailus-X3B1VOXEql0@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 12/28/2015 08:44 AM, Greg KH wrote:
> On Mon, Dec 28, 2015 at 08:37:19AM -0700, Shuah Khan wrote:
>> On 12/28/2015 07:03 AM, Mauro Carvalho Chehab wrote:
>>> There are a few discussions left with regards to this ioctl:
>>>
>>> 1) the name of the new structs will contain _v2_ on it?
>>> 2) what's the best alternative to avoid compat32 issues?
>>>
>>> Due to that, let's postpone the addition of this new ioctl to
>>> the next Kernel version, to give people more time to discuss it.
>>
>> I thought we discussed this in our irc meeting and
>> arrived at a good solution for compat32 issue
>>
>> My recommendation is getting this ioctl into 4.5 with
>> a warning that it could change. The reason for that is
>> that this ioctl helps with testing the media controller
>> v2 api. Without this API, we won't see much testing from
>> userspace in 4.5
> 
> People will ignore the warning, that never works :(
> 

Yeah. If people do ignore warnings, it could become a
problem if we have to make changes.

-- Shuah


-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org | (970) 217-8978

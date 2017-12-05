From: Laura Abbott <labbott-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v6 2/2] staging: ion: create one device entry per heap
Date: Tue, 5 Dec 2017 15:01:42 -0800
Message-ID: <65ef83b2-db3e-eaf6-129f-40e156400624@redhat.com>
References: <1509983985-20950-1-git-send-email-benjamin.gaignard@linaro.org>
 <1509983985-20950-3-git-send-email-benjamin.gaignard@linaro.org>
 <20171128133217.GA29995@kroah.com>
 <CA+M3ks51HFZr62FKsuc6k84ei=scbQDBjtgQy25Mi3RjXhYcyw@mail.gmail.com>
 <20171202155317.GB5311@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171202155317.GB5311-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Benjamin Gaignard <benjamin.gaignard-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Sumit Semwal <sumit.semwal-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOl?= =?UTF-8?Q?g?= <arve-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Riley Andrews <riandrews-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, driverdevel <devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org" <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 12/02/2017 07:53 AM, Greg KH wrote:
>> This is one of the item in the TODO list before been able to unstage ION
>> which is my real need.
> Why does it matter where in the tree this code is?  Don't go adding new
> things to it that are not needed.  Who needs this?  What userspace code
> wants this type of multiple ion devices?
> 

Requirements came in from several places to split /dev/ion -> /dev/ion0
and /dev/ion1 so that security policy (i.e. selinux) could be used to
protect access to certain heaps. I wanted the ABI to be settled before
trying to move out of staging, hence the line in the TODO list about
doing the split.

> thanks,
> 
> greg k-h

Thanks,
Laura

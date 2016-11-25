From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: [PATCH RFC] user-namespaced file capabilities - now with even
 more magic
Date: Fri, 25 Nov 2016 09:33:50 +0100
Message-ID: <d2160ca5-12e5-0be7-ade7-c4ee63e1df32@gmail.com>
References: <20161119151739.GA16398@mail.hallyn.com>
 <8acb3b53-d5eb-0524-2c57-31fcb7e736d9@gmail.com>
 <20161124225246.GA16648@mail.hallyn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161124225246.GA16648@mail.hallyn.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: mtk.manpages@gmail.com, "Eric W. Biederman" <ebiederm@xmission.com>, Seth Forshee <seth.forshee@canonical.com>, lkml <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hi Serge,

On 11/24/2016 11:52 PM, Serge E. Hallyn wrote:
> Quoting Michael Kerrisk (man-pages) (mtk.manpages@gmail.com):

[...]

>> Could we have a man-pages patch for this feature? Presumably for 
>> user_namespaces(7) or capabilities(7).
> 
> capabilities.7 doesn't actually mention anything about user namespaces
> right now.  

True. There's really just this:

   Interaction with user namespaces
       For a discussion of  the  interaction  of  capabilities  and  user
       namespaces, see user_namespaces(7).

> I'll come up with a patch for both I think.  Do you have a
> deadline for a new release coming up?

No deadlines as such. The last couple of years, as a sort of 
experiment, I've fallen into the same release cycle as the kernel
(typically making a release in the week or so after the kernel release),
and I am even using a similar numbering scheme. Ideally, the man-pages
patch would go into the release that corresponds to the kernel release
that makes the change.

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/

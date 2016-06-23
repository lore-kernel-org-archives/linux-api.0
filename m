From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Documenting ptrace access mode checking
Date: Thu, 23 Jun 2016 09:42:09 +0200
Message-ID: <33209000-3fd4-0b26-f249-eb4e1a9e1651@gmail.com>
References: <e335a243-2199-2185-c7b3-fb1c898e9ab4@gmail.com>
 <20160621205550.GA5191@pc.thejh.net>
 <86486234-d78a-234b-58bb-6ca646881dc6@gmail.com>
 <20160622224428.GA15902@pc.thejh.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160622224428.GA15902-J1fxOzX/cBvk1uMJSBkQmQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, James Morris <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Jann,

Thanks for your further review. Follow-up of one point below.

On 06/23/2016 12:44 AM, Jann Horn wrote:
> On Wed, Jun 22, 2016 at 09:21:29PM +0200, Michael Kerrisk (man-pages)=
 wrote:
>> On 06/21/2016 10:55 PM, Jann Horn wrote:
>>> On Tue, Jun 21, 2016 at 11:41:16AM +0200, Michael Kerrisk (man-page=
s) wrote:

[...]

>>>>       The  algorithm  employed for ptrace access mode checking det=
er=E2=80=90
>>>>       mines whether the calling process is  allowed  to  perform  =
the
>>>>       corresponding action on the target process, as follows:
>>>>
>>>>       1.  If the calling thread and the target thread are in the s=
ame
>>>>           thread group, access is always allowed.
>>>>
>>>>       2.  If the access mode specifies PTRACE_MODE_FSCREDS, then  =
for
>>>>           the  check in the next step, employ the caller's filesys=
tem
>>>>           user ID and group ID (see credentials(7));  otherwise  (=
the
>>>>           access  mode  specifies  PTRACE_MODE_REALCREDS, so) use =
the
>>>>           caller's real user ID and group ID.
>>>
>>> Might want to add a "for historical reasons" or so here.
>>
>> Can you be a little more precise about "here", and maybe tell me why
>> you think it helps?
>
> I'm not sure, but it might be a good idea to add something like this =
at the
> end of 2.:
> "(Most other APIs that check one of the caller's UIDs use the effecti=
ve one.
> This API uses the real UID instead for historical reasons.)"
>
> In my opinion, it is inconsistent to use the real UID/GID here, the
> effective one would be more appropriate. But since the existing code =
uses
> the real UID/GID and that's not a security issue for existing users o=
f
> the ptrace API, this wasn't changed when I added the REALCREDS/FSCRED=
S
> distinction.
>
> I think that for a reader, it might help to point out that in most ca=
ses,
> when a process is the subject in an access check, its effective UID/G=
ID
> are used, and this is (together with kill()) an exception to that rul=
e.
> But you're the expert on writing documentation, if you think that tha=
t's
> too much detail / confusing here, it probably is.

Okay -- got it now, I think. I made this text:

        2.  If the access mode specifies PTRACE_MODE_FSCREDS, then, for
            the check in the next step, employ the caller's  filesystem
            UID  and  GID.  (As noted in credentials(7), the filesystem
            UID and GID almost always have the same values as the  cor=E2=
=80=90
            responding effective IDs.)

            Otherwise, the access mode specifies PTRACE_MODE_REALCREDS,
            so use the caller's real UID and GID for the checks in  the
            next  step.  (Most APIs that check the caller's UID and GID
            use  the  effective  IDs.   For  historical  reasons,   the
            PTRACE_MODE_REALCREDS check uses the real IDs instead.)

[...]

Cheers,

Michael



--=20
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/

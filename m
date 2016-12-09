From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [PATCH RFC] user-namespaced file capabilities - now with even more magic
Date: Fri, 09 Dec 2016 21:03:51 +1300
Message-ID: <87oa0ljzq0.fsf@xmission.com>
References: <20161119151739.GA16398@mail.hallyn.com>
        <87inqvav4y.fsf@xmission.com> <20161208045640.GA433@mail.hallyn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161208045640.GA433-7LNsyQBKDXoIagZqoN9o3w@public.gmane.org> (Serge E. Hallyn's message
        of "Wed, 7 Dec 2016 22:56:40 -0600")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Cc: Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

"Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org> writes:

> On Thu, Dec 08, 2016 at 05:43:09PM +1300, Eric W. Biederman wrote:
>> "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org> writes:

>> Any chance of a singed-off-by?
>
> Yes, sorry, Stéphane had pointed out that I'd apparently forgotten to do
> -s.  Do you want me to resend the whole shebang, or does
>
> Signed-off-by: Serge Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
>
> suffice?  (My previous iterations did have it fwiw so I don't think I could
> legally disavow it now :)

I was really hoping to get this in this for 4.10, but I am seeing a couple
of little things in my review.  Comments referring to a non-existent v4
and a few other niggling little things so I am going to target this for
the next kernel release so there is time review.  With a little luck I
can place this patch in my for-next tree just after the merge window
closes and 4.10-rc1 ships.



Eric

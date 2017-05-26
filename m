From: "Luis R. Rodriguez" <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] firmware: fix sending -ERESTARTSYS due to signal on
 fallback
Date: Fri, 26 May 2017 21:46:40 +0200
Message-ID: <20170526194640.GS8951@wotan.suse.de>
References: <20170524205658.GK8951@wotan.suse.de>
 <20170524214027.7775-1-mcgrof@kernel.org>
 <CALCETrXUrirO-vg3M+MGhn=0gZTwx0phsRDS4TCwWWgNYC6RsA@mail.gmail.com>
 <CAB=NE6VENGmTEZ3_8EWmv6bhT81k=szg0_POWJm2SP+V21CeBw@mail.gmail.com>
 <CALCETrU4__YUGk36PN=FbuEf0SBaTrxQQqm4sWs2NrZ+6WN7jA@mail.gmail.com>
 <CANh8QzwPb_+RKs5QVt7mdFk8h_rOMVS3j9m0OADgvzBtNqBBLg@mail.gmail.com>
 <87fufr3mdy.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <87fufr3mdy.fsf-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: "Fuzzey, Martin" <mfuzzey-mB3Nsq4MPf1BDgjK7y7TUQ@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Luis R. Rodriguez" <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Daniel Wagner <wagi-kQCPcA+X3s7YtjvyW6yDsg@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, jewalt-d4N2ExZK1jaSe5ORCPIMD9BPR1lH4CV8@public.gmane.org, rafal-g1n6cQUeyibVItvQsEIGlw@public.gmane.org, Arend Van Spriel <arend.vanspriel-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, "Li, Yi" <yi1.li-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, atull-yzvPICuk2ABMcg4IHK0kFoH6Mc4MB0Vx@public.gmane.org, Moritz Fischer <moritz.fischer-+aYTwkv1SeIAvxtiuMwx3w@public.gmane.org>, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, Johannes Berg <johannes.berg-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Emmanuel Grumbach <emmanuel.grumbach-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Luca Coelho <luciano.coelho-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, May 26, 2017 at 06:09:29AM -0500, Eric W. Biederman wrote:
> "Fuzzey, Martin" <mfuzzey-mB3Nsq4MPf1BDgjK7y7TUQ@public.gmane.org> writes:
> >>>> Maybe SIGCHLD shouldn't interrupt firmware loading?
> >
> > I don't think there's a way of doing that without disabling all
> > signals (ie using the non interruptible wait variants).
> > It used to be that way (which is why I only ran into this after
> > updating from an ancient 3.16 kernel to a slightly less ancient 4.4)
> > But there are valid reasons for wanting to be able to interrupt
> > firmware loading (like being able to kill the userspace helper)
> 
> Perhaps simply using a killable wait and not a fully interruptible
> wait would be better?

What do you mean by a killable wait BTW?

ret = swait_event_interruptible_timeout() is being used right now.

The problem is we have:

        if (ret != 0 && fw_st->status == FW_STATUS_ABORTED)                     
                return -ENOENT;                                                 
        if (!ret)                                                               
                return -ETIMEDOUT;                                              
                                                                                
        return ret < 0 ? ret : 0;  

The (!ret) return -ETIMEDOUT ensures that if there was no time left
then we know we ran out of time.

The ret < 0 ? ret makes sure we send any errors
swait_event_interruptible_timeout() sent.

But the caller of this code has:

        if (fw_state_is_aborted(&buf->fw_st))                                   
                retval = -EAGAIN;                                               
        else if (buf->is_paged_buf && !buf->data)                               
                retval = -ENOMEM; 

And this retval is used. so we mask all errors with -EAGAIN.

So Martin is asking us to let us send -ERESTARTSYS back down to drivers.
These potentially could send back down to probe, and so finit_module()
could get this.

Another use case is a custom syfs knob which triggers a request_firmware(),
in such case this is a simple write(), but Anroid is configured to retry
if -ERESTARTSYS so I gather it will *retry* writing again to this file
if -ERESTARTSYS was sent and therefore triggering another firmware request.

> It sounds like the code really is not prepared for an truly
> interruptible wait here.

Can you clarify what you mean?

  Luis

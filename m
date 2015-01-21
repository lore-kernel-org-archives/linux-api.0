From: Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 01/13] kdbus: add documentation
Date: Wed, 21 Jan 2015 10:12:17 +0100
Message-ID: <54BF6D71.7000707@zonque.org>
References: <1421435777-25306-1-git-send-email-gregkh@linuxfoundation.org> <1421435777-25306-2-git-send-email-gregkh@linuxfoundation.org> <54BE5F1F.8070703@gmail.com> <54BF6C67.7090909@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54BF6C67.7090909-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, arnd-r2nGTMty4D4@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org, teg-B22kvLQNl6c@public.gmane.org, jkosina-AlSwsSmVLrQ@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 01/21/2015 10:07 AM, Michael Kerrisk (man-pages) wrote:
> On 01/20/2015 02:58 PM, Michael Kerrisk (man-pages) wrote:

>>> +Also, if the connection allowed for file descriptor to be passed
>>> +(KDBUS_HELLO_ACCEPT_FD), and if the message contained any, they will be
>>> +installed into the receiving process after the KDBUS_CMD_RECV ioctl returns.
>>
>> ###
>> "after"??? When exactly?
> 
> By the way, what was the answer to this question?

I've corrected the wording on this. The file descriptors are installed
when the RECV ioctl is called, so they are ready to use when the call
returns.


Thanks,
Daniel

From: Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 01/13] kdbus: add documentation
Date: Tue, 27 Jan 2015 19:14:11 +0100
Message-ID: <54C7D573.7080809@zonque.org>
References: <1421435777-25306-1-git-send-email-gregkh@linuxfoundation.org>	<1421435777-25306-2-git-send-email-gregkh@linuxfoundation.org>	<54BE5DC8.70706@gmail.com>	<54BE9D08.7010804@zonque.org>	<54BF805B.4000609@gmail.com>	<54BFDAAA.50203@zonque.org>	<54C0CE8A.5080805@gmail.com>	<20150123155402.GB2159@kroah.com>	<54C65267.7090905@gmail.com>	<CAG-2HqUCZjc4Ucc-L21uG6e-di4UcLJAT5mW_-5-c-uqmoJyzA@mail.gmail.com>	<54C66F30.8050108@gmail.com> <CANq1E4TtBhA6Ygu9qMU8xVxbL9q+ZBqnfdU0ceeTTfam9aT+=w@mail.gmail.com> <54C7D0A3.4000900@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54C7D0A3.4000900-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Tom Gundersen <teg-B22kvLQNl6c@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, One Thousand Gnomes <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org>, Johannes Stezenbach <js-FF7aIK3TAVNeoWH0uzbU5w@public.gmane.org>, Theodore T'so <tytso-3s7WtUTddSA@public.gmane.org>, christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Michael,

On 01/27/2015 06:53 PM, Michael Kerrisk (man-pages) wrote:
> On 01/27/2015 04:23 PM, David Herrmann wrote:

>> I only expect a handful of users to call the ioctls directly. The
>> libraries that implement the payload-marshaling, in particular. It's a
>> similar situation with netlink.
> 
> Thanks, David, for the clarification. I think it would have been helpful
> to have that more clearly stated up front, especially as some comments 
> in this thread, such as the above, could be interpreted to mean quite 
> the opposite. Can I suggest that some text on this point be added to 
> kdbus.txt?

We're currently working on an a set of comprehensive man pages to
document all the commands in the API, along with every struct, enum etc.
We do that so that developers are able to actually understand every
detail of the API, even though most people - as David explained - will
not use that interface directly in the first place but let one of the
high-level libraries help them integrate D-Bus functionality into their
applications.

If you want, have a look at the upstream repository for a 	preliminary
version of the new docs.


Thanks,
Daniel

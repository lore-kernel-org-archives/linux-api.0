From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [PATCH 2/4] clone.2: Describe the user namespace
Date: Thu, 27 Dec 2012 09:47:03 -0800
Message-ID: <87sj6rs7zc.fsf@xmission.com>
References: <87a9u4rmz0.fsf@xmission.com> <87y5hnq3d5.fsf@xmission.com>
	<CAKgNAkgXWp49wXKom9hMm9fajKVOAwOmFzPdKWBesbBhfZEssA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <CAKgNAkgXWp49wXKom9hMm9fajKVOAwOmFzPdKWBesbBhfZEssA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
	(Michael Kerrisk's message of "Thu, 27 Dec 2012 11:16:17 +0100")
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Id: linux-api@vger.kernel.org


There is one other bit that needs to be documented in clone, although
I am not certain where/how.

The sequences:

unshare(CLONE_NEWPID).
clone(CLONE_VM)

setns(fd, CLONE_NEWPID).
clone(CLONE_VM).

Now fail.

Basically the rule is all threads must be in the same pid namespace.

The joy of reviews with good comments that come much later than hoped.

Eric

From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [REVIEW][PATCH 0/4] /proc/thread-self
Date: Fri, 01 Aug 2014 00:01:13 -0700
Message-ID: <8738dgae2u.fsf@x220.int.ebiederm.org>
References: <87oaw5caq1.fsf@x220.int.ebiederm.org>
	<53DB3790.7020600@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <53DB3790.7020600-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> (Randy Dunlap's message of "Thu,
	31 Jul 2014 23:45:36 -0700")
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> writes:

> On 07/31/14 17:30, Eric W. Biederman wrote:
>> 
>> This patchset implements /proc/thread-self a magic symlink that
>> solves a couple of problems.
>> 
>> - It makes it easy to get to a specific threads directory in /proc
>>   with gettid() not being exported in glibc this is currently a pain.
>> 
>> - It allows fixing the problem present in /proc/mounts and /proc/net
>>   that when the thread group leader exits but the entire thread group
>>   remains /proc/self/net and /proc/self/mounts and thus /proc/mounts and
>>   /proc/net become empty.
>> 
>> - As mount and network namespaces are per thread it allows /proc/net and
>>   /proc/mounts to reflect this.
>
> Hi Eric,
>
> Any changes/additions to Documentation/ ?

Not at this time.  I can imagine that there is proc manpage that might
need a line or two of Documentation.

I am not familiar with anything in Documentation that descripes any of
this and would benefit from an update.  From an overview perspective I
can see documenting this so people know thread-self exists.  From an
actual usage perspective:

  $ ls -l /proc/thread-self
  lrwxrwxrwx 1 root root 0 Aug  1 00:00 /proc/thread-self -> 484/task/484

seems like pretty comprehensive documentation to me.

Eric

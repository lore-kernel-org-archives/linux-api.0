From: Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCHv2 7/7] cgroup: mount cgroupns-root when inside non-init
	cgroupns
Date: Mon, 3 Nov 2014 16:49:41 -0800
Message-ID: <CAGr1F2Ecd3vCkDHVpFevZDLt+J49MimYh0va9u7JEJVTLHq8uQ@mail.gmail.com>
References: <1414783141-6947-1-git-send-email-adityakali@google.com>
	<1414783141-6947-8-git-send-email-adityakali@google.com>
	<CALCETrXTaZ3SJ_t-gnbc93BVZXg-912NqO78kFd0Tpi-5-dZoQ@mail.gmail.com>
	<CAGr1F2FuPQxLraYv7PstJ9c8H-XQsgawaAtj4AS77B+_0k2o+A@mail.gmail.com>
	<CALCETrW64-6xC6psP-8k0H-1GfVnWBTeEBNSrE_sH+-DFtuZQQ@mail.gmail.com>
	<CAGr1F2GX45gC-V7kEzVjp-EiYfdPDVBRs+99nASpgFVAdYX+1w@mail.gmail.com>
	<CALCETrUB_xx5zno26k5UjAFt77nZTpgyndD4AuBSZxiZBNjXSw@mail.gmail.com>
	<CAGr1F2EV4p_nJP_oMe3N8pBPedAZHbdB=XCMPjSEZTC9jmZoAg@mail.gmail.com>
	<CALCETrXeG2t=fW9HbkirDZudw9pbDwoqDq5ygJBkBMbqqoDAvw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <CALCETrXeG2t=fW9HbkirDZudw9pbDwoqDq5ygJBkBMbqqoDAvw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Nov 3, 2014 at 4:17 PM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
> On Mon, Nov 3, 2014 at 4:12 PM, Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>> On Mon, Nov 3, 2014 at 3:48 PM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
>>> On Mon, Nov 3, 2014 at 3:23 PM, Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>>>> On Mon, Nov 3, 2014 at 3:15 PM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
>>>>> On Mon, Nov 3, 2014 at 3:12 PM, Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>>>>>> On Fri, Oct 31, 2014 at 5:07 PM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
>>>>>>> On Fri, Oct 31, 2014 at 12:19 PM, Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>>>>>>>>         if (opts->flags & CGRP_ROOT_SANE_BEHAVIOR) {
>>>>>>>>                 pr_warn("sane_behavior: this is still under development and its behaviors will change, proceed at your own risk\n");
>>>>>>>> -               if (nr_opts != 1) {
>>>>>>>> +               if (nr_opts > 1) {
>>>>>>>>                         pr_err("sane_behavior: no other mount options allowed\n");
>>>>>>>>                         return -EINVAL;
>>>>>>>
>>>>>>> This looks wrong.  But, if you make the change above, then it'll be right.
>>>>>>>
>>>>>>
>>>>>> It would have been nice if simple 'mount -t cgroup cgroup <mnt>' from
>>>>>> cgroupns does the right thing automatically.
>>>>>>
>>>>>
>>>>> This is a debatable point, but it's not what I meant.  Won't your code
>>>>> let 'mount -t cgroup -o one_evil_flag cgroup mountpoint' through?
>>>>>
>>>>
>>>> I don't think so. This check "if (nr_opts > 1)" is nested under "if
>>>> (opts->flags & CGRP_ROOT_SANE_BEHAVIOR)". So we know that there is
>>>> atleast 1 option ('__DEVEL__sane_behavior') present (implicit or not).
>>>> Addition of 'one_evil_flag' will make nr_opts = 2 and result in EINVAL
>>>> here.
>>>
>>> But the implicit __DEVEL__sane_behavior doesn't increment nr_opts, right?
>>>
>>
>> Yes. Hence this change makes sure that we don't return EINVAL when
>> nr_opts == 0 or nr_opts == 1 :)
>> That way, both of the following are equivalent when inside non-init cgroupns:
>>
>> (1) $ mount -t cgroup -o __DEVEL__sane_behavior cgroup mountpoint
>> (2) $ mount -t cgroup cgroup mountpoint
>>
>> Any other mount option will trigger the error here.
>
> I still don't get it.  Can you walk me through why mount -o
> some_other_option -t cgroup cgroup mountpoint causes -EINVAL?
>

Argh! You are right. I was totally convinced that this works. But it
clearly doesn't if you specify 1 legit mount option. I wanted to make
it work for both cases (1) and (2) above. But then this check will
have to be changed :(
Sorry about the back and forth. I am just going to make it return
EINVAL if __DEVEL_sane_behavior is not specified as suggested in the
beginning.

> --Andy

-- 
Aditya

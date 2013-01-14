From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/4] proc.5: Document /proc/[pid]/uid_map and
	/proc/[pid]/gid_map
Date: Mon, 14 Jan 2013 09:59:08 +0100
Message-ID: <CAKgNAkg5av_p6pf0R0NRw_YbgQGjJXKATaH2eu1OczYDo7oMuA@mail.gmail.com>
References: <87a9u4rmz0.fsf@xmission.com> <874nkbrhyv.fsf@xmission.com>
	<CAKgNAkixXmtvQUbwyv=a8mU=gdf-x+w-ou_4N=cNaau+hVoy4Q@mail.gmail.com>
	<87obhfxwhb.fsf@xmission.com>
	<CAKgNAkjs9T-s8SG-EgTT0O-Uj8S98Q_zfnMqnZ1ROrcYqh7Z5w@mail.gmail.com>
	<87vcbldgbj.fsf@xmission.com>
	<CAKgNAkjf=KS5FnP0L-TPTCjQuTDAMs-N4cadAP89L4Mb3KubzQ@mail.gmail.com>
	<87r4m51abp.fsf@xmission.com>
Reply-To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <87r4m51abp.fsf-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Eric,

On Tue, Jan 1, 2013 at 11:12 AM, Eric W. Biederman
<ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> wrote:
> "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> writes:
>
>> Hi Eric,
>>
>> On Fri, Dec 28, 2012 at 10:20 PM, Eric W. Biederman
>> <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> wrote:
>>> "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> writes:
>>
>> [...]
>>
>>>>> For writing you are correct about the mapping to the parent (but that is
>>>>> not an exception that is a restriction on who can write to the file).
>>>>
>>>> So, by the way, I added this sentence to the page:
>>>>
>>>>               In   order   to   write   to   the   /proc/[pid]/uid_map
>>>>               (/proc/[pid]/gid_map) file,  a  process  must  have  the
>>>>               CAP_SETUID (CAP_SETGID) capability in the user namespace
>>>>               of the process pid.
>>>>
>>>> Is that correct?
>>>
>>> Yes.
>>>
>>>> But, there appear to be more rules than this governing whether a
>>>> process can write to the file (i.e., various other -EPERM cases). What
>>>> are the rules?
>>>
>>> In general you must also have CAP_SETUID (CAP_SETGID) in the parent user
>>> namespace as well.  The one exception to that is if you are mapping
>>> your current uid and gid.
>>
>> Can you clarify what you mean by "mapping your own UID and GID" please
>> (i.e., who is "you" in that sentence).
>
> At the time of clone() or unshare() that creates a new user namespace,
> the kuid and the kgid of the process does not change.
>
> setuid and setgid fail before any mappings are set up.
>
> Therefore the caller is allowed to map any single uid to the uid of the
> caller in the parent user namespace.  Likewise the caller is allowed to
> map any single gid to the gid of the caller in the parent user
> namespace.

So, then is the following text now correct and complete:

       In  order  for  a  process  to write to the /proc/[pid]/uid_map
       (/proc/[pid]/gid_map) file, the following requirements must  be
       met:

       *  The process must have the CAP_SETUID (CAP_SETGID) capability
          in the user namespace of the process pid.

       *  The process must have the CAP_SETUID (CAP_SETGID) capability
          in the parent user namespace.  There is an exception to this
          requirement: a  process  writing  to  uid_map  (gid_map)  is
          allowed  to  map any single UID (GID) to the file system UID
          (GID) of the caller in the parent user namespace.

       *  The process must be in either  the  user  namespace  of  the
          process  pid  or  inside  the  parent  user namespace of the
          process pid.

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/

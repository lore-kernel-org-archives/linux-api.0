From: Aleksa Sarai <asarai-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [GIT PULL] namespaces related fixes for v4.11-rc1
Date: Thu, 23 Feb 2017 13:21:42 +1100
Message-ID: <fc5d9877-da20-844f-22af-090ffb267a45@suse.de>
References: <8760k29cku.fsf@xmission.com>
	<84361910-ba16-79ff-09cd-c76b3f66cc85@suse.de>
	<8737f54rue.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <8737f54rue.fsf-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
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
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

>>> The only known user of this prctl systemd
>>> forks all children after the prctl.  So no userspace regressions will
>>> occur.
>>
>> Note that runC and containerd (and thus Docker) as well as cri-o use the prctl
>> as well -- to be able to collect exit codes from a non-child process (namely to
>> collect the exit code from PID 1 in the container).
>
> Are any of those affected by the change?  I would not expect so.  As it
> would require having children or grand children whose exit codes you
> don't want to collect.

AFAICS they do appear to work (and runC definitely calls the prctl 
before it creates the container init process -- so it shouldn't break 
anything for runC). I was just pointing out that systemd isn't the only 
major userspace user of the prctl (for future reference).

-- 
Aleksa Sarai
Software Engineer (Containers)
SUSE Linux GmbH
https://www.cyphar.com/

From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH V2] Test compaction of mlocked memory
Date: Thu, 23 Apr 2015 13:23:23 -0700
Message-ID: <20150423132323.a3bd1dcdc94a2da3ca06a30d@linux-foundation.org>
References: <1429813301-27216-1-git-send-email-sjayaram@akamai.com>
	<20150423184134.GF2282@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150423184134.GF2282-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eric B Munson <emunson-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
Cc: Sri Jayaramappa <sjayaram-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, 23 Apr 2015 14:41:34 -0400 Eric B Munson <emunson-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org> wrote:

> On Thu, 23 Apr 2015, Sri Jayaramappa wrote:
> 
> > Commit commit 5bbe3547aa3b ("mm: allow compaction of unevictable pages")
> > introduced a sysctl that allows userspace to enable scanning of locked
> > pages for compaction.  This patch introduces a new test which fragments
> > main memory and attempts to allocate a number of huge pages to exercise
> > this compaction logic.
> > 
> > Tested on machines with up to 32 GB RAM. With the patch a much larger
> > number of huge pages can be allocated than on the kernel without the
> > patch.
> > 
> > Example output:
> > On a machine with 16 GB RAM:
> > sudo make run_tests vm
> > ...
> > -----------------------
> > running compaction_test
> > -----------------------
> > No of huge pages allocated = 3834
> > [PASS]
> > ...
> > 
> > Signed-off-by: Sri Jayaramappa <sjayaram-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
> > Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> > Cc: Eric B Munson <emunson-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
> 
> Reviewed-by: Eric B Munson <emunson-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>

Acked-by: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

I'm assuming that Shuah will process this one?

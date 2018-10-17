From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH v3 2/2] sysctl: handle overflow for file-max
Date: Wed, 17 Oct 2018 11:57:11 +0200
Message-ID: <20181017095709.6wx6wzhbbezgeybh@brauner.io>
References: <20181016223322.16844-1-christian@brauner.io>
 <20181016223322.16844-3-christian@brauner.io>
 <20181017003548.GA32577@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181017003548.GA32577@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: keescook@chromium.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com, mcgrof@kernel.org, akpm@linux-foundation.org, joe.lawrence@redhat.com, longman@redhat.com, linux@dominikbrodowski.net, adobriyan@gmail.com, linux-api@vger.kernel.org, Andrea Arcangeli <aarcange@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, Eric Dumazet <eric.dumazet@gmail.com>
List-Id: linux-api@vger.kernel.org

On Wed, Oct 17, 2018 at 01:35:48AM +0100, Al Viro wrote:
> On Wed, Oct 17, 2018 at 12:33:22AM +0200, Christian Brauner wrote:
> > Currently, when writing
> > 
> > echo 18446744073709551616 > /proc/sys/fs/file-max
> > 
> > /proc/sys/fs/file-max will overflow and be set to 0. That quickly
> > crashes the system.
> > This commit sets the max and min value for file-max and returns -EINVAL
> > when a long int is exceeded. Any higher value cannot currently be used as
> > the percpu counters are long ints and not unsigned integers. This behavior
> > also aligns with other tuneables that return -EINVAL when their range is
> > exceeded. See e.g. [1], [2] and others.
> 
> Mostly sane, but...  get_max_files() users are bloody odd.  The one in
> file-max limit reporting looks like a half-arsed attempt in "[PATCH] fix
> file counting".  The one in af_unix.c, though...  I don't remember how
> that check had come to be - IIRC that was a strange fallout of a thread
> with me, Andrea and ANK involved, circa 1999, but I don't remember details;
> Andrea, any memories?  It might be worth reconsidering...  The change in
> question is in 2.2.4pre6; what do we use unix_nr_socks for?  We try to
> limit the number of PF_UNIX socks by 2 * max_files, but max_files can be

So that's something I mentioned to Kees before. It seems we should
either simply replace this check with:

        if ((atomic_long_read(&unix_nr_socks) >> 1) > get_max_files())
                goto out;

to protect against overflows or simply do

        if (atomic_long_read(&unix_nr_socks) > get_max_files())
                goto out;

> huge *and* non-constant (i.e. it can decrease).  What's more, unix_tot_inflight
> is unsigned int and max_files might exceed 2^31 just fine since "fs: allow
> for more than 2^31 files" back in 2010...  Something's fishy there...

What's more is that fs/file_table.c:files_maxfiles_init()
currently has:
void __init files_maxfiles_init(void)
{
        unsigned long n;
        unsigned long memreserve = (totalram_pages - nr_free_pages()) * 3/2;

        memreserve = min(memreserve, totalram_pages - 1);
        n = ((totalram_pages - memreserve) * (PAGE_SIZE / 1024)) / 10;

        files_stat.max_files = max_t(unsigned long, n, NR_FILE);
}

given that we currently can't handle more than LONG_MAX files should we
maybe cap here? Like:

diff --git a/fs/file_table.c b/fs/file_table.c
index e49af4caf15d..dd108b4c6d72 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -376,6 +376,8 @@ void __init files_init(void)
 /*
  * One file with associated inode and dcache is very roughly 1K. Per default
  * do not use more than 10% of our memory for files.
+ * The percpu counters only handle long ints so cap maximum number of
+ * files at LONG_MAX.
  */
 void __init files_maxfiles_init(void)
 {
@@ -386,4 +388,7 @@ void __init files_maxfiles_init(void)
        n = ((totalram_pages - memreserve) * (PAGE_SIZE / 1024)) / 10;

        files_stat.max_files = max_t(unsigned long, n, NR_FILE);
+
+       if (files_stat.max_files > LONG_MAX)
+               files_stat.max_files = LONG_MAX;
 }

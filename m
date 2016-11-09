From: Cyrill Gorcunov <gorcunov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/2] kernel: Move prctl and helpers from kernel/sys.c to
 new kernel/prctl.c
Date: Wed, 9 Nov 2016 10:02:38 +0300
Message-ID: <20161109070238.GA1870@uranus.lan>
References: <cover.c693f10dfc19e12c214758e4b13ca9b4e4cf9668.1478650356.git-series.josh@joshtriplett.org>
 <afb9a2bb41be9e129ececea27e09a7d69d1c5e6c.1478650356.git-series.josh@joshtriplett.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <afb9a2bb41be9e129ececea27e09a7d69d1c5e6c.1478650356.git-series.josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, Thomas Garnier <thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Nicolas Pitre <nicolas.pitre-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Li Bin <huawei.libin-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ralf Baechle <ralf-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org>, Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Mateusz Guzik <mguzik-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Zach Brown <zab-H+wXaHxf7aJhl2p70BpVqQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Nov 08, 2016 at 04:18:13PM -0800, Josh Triplett wrote:
> This prepares for making prctl optional.
> 
> Signed-off-by: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
> +
...
> +static int prctl_set_mm_exe_file(struct mm_struct *mm, unsigned int fd)
> +{
> +	struct fd exe;
> +	struct file *old_exe, *exe_file;
> +	struct inode *inode;
> +	int err;
> +
> +	exe = fdget(fd);
> +	if (!exe.file)
> +		return -EBADF;
> +
> +	inode = file_inode(exe.file);
> +
> +	/*
> +	 * Because the original mm->exe_file points to executable file, make
> +	 * sure that this one is executable as well, to avoid breaking an
> +	 * overall picture.
> +	 */
> +	err = -EACCES;
> +	if (!S_ISREG(inode->i_mode) || path_noexec(&exe.file->f_path))
> +		goto exit;
> +
> +	err = inode_permission(inode, MAY_EXEC);
> +	if (err)
> +		goto exit;
> +
> +	/*
> +	 * Forbid mm->exe_file change if old file still mapped.
> +	 */
> +	exe_file = get_mm_exe_file(mm);
> +	err = -EBUSY;
> +	if (exe_file) {
> +		struct vm_area_struct *vma;
> +
> +		down_read(&mm->mmap_sem);
> +		for (vma = mm->mmap; vma; vma = vma->vm_next) {
> +			if (!vma->vm_file)
> +				continue;
> +			if (path_equal(&vma->vm_file->f_path,
> +				       &exe_file->f_path))
> +				goto exit_err;
> +		}
> +
> +		up_read(&mm->mmap_sem);
> +		fput(exe_file);
> +	}
> +
> +	/*
> +	 * The symlink can be changed only once, just to disallow arbitrary
> +	 * transitions malicious software might bring in. This means one
> +	 * could make a snapshot over all processes running and monitor
> +	 * /proc/pid/exe changes to notice unusual activity if needed.
> +	 */
> +	err = -EPERM;
> +	if (test_and_set_bit(MMF_EXE_FILE_CHANGED, &mm->flags))
> +		goto exit;

IIRC this snippet has been dropped in linux-next tree. Stas CC'ed.
The rest looks cool for me. Thanks!

Reviewed-by: Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>

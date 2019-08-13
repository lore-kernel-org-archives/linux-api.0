From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH V37 27/29] tracefs: Restrict tracefs when the kernel is
 locked down
Date: Tue, 13 Aug 2019 09:21:09 +0200
Message-ID: <3028ed35-3b6d-459f-f3c8-103c5636fe95@samsung.com>
References: <20190731221617.234725-1-matthewgarrett@google.com>
        <20190731221617.234725-28-matthewgarrett@google.com>
        <a3caa6d3-e3f9-ae41-d87e-253d9dc53d81@samsung.com>
        <CGME20190813072111eucas1p2b87f3f8d16c22a0a3d024bc5ebcc8bcc@eucas1p2.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <a3caa6d3-e3f9-ae41-d87e-253d9dc53d81@samsung.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <matthewgarrett@google.com>, jmorris@namei.org
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Matthew Garrett <mjg59@google.com>, Steven Rostedt <rostedt@goodmis.org>, Krzysztof Kozlowski <krzk@kernel.org>
List-Id: linux-api@vger.kernel.org

Hi again,

On 2019-08-13 08:10, Marek Szyprowski wrote:
> Hi
>
> On 2019-08-01 00:16, Matthew Garrett wrote:
>> Tracefs may release more information about the kernel than desirable, so
>> restrict it when the kernel is locked down in confidentiality mode by
>> preventing open().
>>
>> Signed-off-by: Matthew Garrett <mjg59@google.com>
>> Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
>
> This patch causes the following regression on various Samsung Exynos 
> SoC based boards (ARM 32bit):
>
> [   15.364422] Unable to handle kernel NULL pointer dereference at 
> virtual address 00000000
> [   15.368775] pgd = a530ddbe
> [   15.371447] [00000000] *pgd=bcd7c831
> [   15.374993] Internal error: Oops: 80000007 [#1] PREEMPT SMP ARM
> [   15.380890] Modules linked in:
> [   15.383929] CPU: 0 PID: 1393 Comm: perf Not tainted 
> 5.2.0-00027-g757ff7244358-dirty #6459
> [   15.392086] Hardware name: SAMSUNG EXYNOS (Flattened Device Tree)
> [   15.398164] PC is at 0x0
> [   15.400687] LR is at do_dentry_open+0x22c/0x3b0
> [   15.405193] pc : [<00000000>]    lr : [<c02977c4>]    psr: 60000053
> [   15.411442] sp : e7317dd8  ip : 00000000  fp : 00000000
> [   15.416650] r10: c0187e6c  r9 : c041f8cc  r8 : e72123c8
> [   15.421858] r7 : e7317ec0  r6 : e7d89630  r5 : 00000000  r4 : e72123c0
> [   15.428368] r3 : 00000000  r2 : 5ba370f3  r1 : e72123c0  r0 : e7d89630
> [   15.434880] Flags: nZCv  IRQs on  FIQs off  Mode SVC_32  ISA ARM  
> Segment none
> [   15.442083] Control: 10c5387d  Table: 6726404a  DAC: 00000051
> [   15.447812] Process perf (pid: 1393, stack limit = 0x17621431)
> [   15.453628] Stack: (0xe7317dd8 to 0xe7318000)
> ...
> [   15.604842] [<c02977c4>] (do_dentry_open) from [<c02aafc8>] 
> (path_openat+0x5a0/0x1004)
> [   15.612735] [<c02aafc8>] (path_openat) from [<c02acce8>] 
> (do_filp_open+0x6c/0xd8)
> [   15.620200] [<c02acce8>] (do_filp_open) from [<c0298cc4>] 
> (do_sys_open+0x130/0x1f4)
> [   15.627839] [<c0298cc4>] (do_sys_open) from [<c0101000>] 
> (ret_fast_syscall+0x0/0x28)
> [   15.635560] Exception stack(0xe7317fa8 to 0xe7317ff0)
> [   15.640596] 7fa0:                   0022dc0b 001deee0 ffffff9c 
> beb6d764 00020000 00000000
> [   15.648756] 7fc0: 0022dc0b 001deee0 0022dba8 00000142 001ba044 
> 00241d68 001a13d8 beb6e78c
> [   15.656913] 7fe0: b6f7e000 beb6c6f8 9a27c600 b6f69504
> [   15.661952] Code: bad PC value
> [   15.665105] ---[ end trace 7e8b864582108f4a ]---
>
> This is standard ARM 32bit kernel with 
> arch/arm/configs/exynos_defconfig. It is enough to run "perf list" 
> command.
>
>> ---
>>   fs/tracefs/inode.c           | 40 +++++++++++++++++++++++++++++++++++-
>>   include/linux/security.h     |  1 +
>>   security/lockdown/lockdown.c |  1 +
>>   3 files changed, 41 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/tracefs/inode.c b/fs/tracefs/inode.c
>> index 1387bcd96a79..12a325fb4cbd 100644
>> --- a/fs/tracefs/inode.c
>> +++ b/fs/tracefs/inode.c
>> @@ -21,6 +21,7 @@
>>   #include <linux/seq_file.h>
>>   #include <linux/magic.h>
>>   #include <linux/slab.h>
>> +#include <linux/security.h>
>>     #define TRACEFS_DEFAULT_MODE    0700
>>   @@ -28,6 +29,23 @@ static struct vfsmount *tracefs_mount;
>>   static int tracefs_mount_count;
>>   static bool tracefs_registered;
>>   +static int default_open_file(struct inode *inode, struct file *filp)
>> +{
>> +    struct dentry *dentry = filp->f_path.dentry;
>> +    struct file_operations *real_fops;
>> +    int ret;
>> +
>> +    if (!dentry)
>> +        return -EINVAL;
>> +
>> +    ret = security_locked_down(LOCKDOWN_TRACEFS);
>> +    if (ret)
>> +        return ret;
>> +
>> +    real_fops = dentry->d_fsdata;
>
> real_fops are NULL in my test case.

Too much of a hurry. real_fops are okay in that test case...

>
>> +    return real_fops->open(inode, filp);

... the issue is caused by NULL ->open() callback. Switching the above 
line to:

return real_fops->open ? real_fops->open(inode, filp) : 0;

fixes the issue.

>> +}
>> +
>>   static ssize_t default_read_file(struct file *file, char __user *buf,
>>                    size_t count, loff_t *ppos)
>>   {
>> @@ -210,6 +228,12 @@ static int tracefs_apply_options(struct 
>> super_block *sb)
>>       return 0;
>>   }
>>   +static void tracefs_destroy_inode(struct inode *inode)
>> +{
>> +    if (S_ISREG(inode->i_mode))
>> +        kfree(inode->i_fop);
>> +}
>> +
>>   static int tracefs_reconfigure(struct fs_context *fc)
>>   {
>>       struct super_block *sb = fc->root->d_sb;
>> @@ -236,6 +260,7 @@ static int tracefs_show_options(struct seq_file 
>> *m, struct dentry *root)
>>     static const struct super_operations tracefs_super_operations = {
>>       .statfs        = simple_statfs,
>> +    .destroy_inode  = tracefs_destroy_inode,
>>       .show_options    = tracefs_show_options,
>>   };
>>   @@ -372,6 +397,7 @@ struct dentry *tracefs_create_file(const char 
>> *name, umode_t mode,
>>                      struct dentry *parent, void *data,
>>                      const struct file_operations *fops)
>>   {
>> +    struct file_operations *proxy_fops;
>>       struct dentry *dentry;
>>       struct inode *inode;
>>   @@ -387,8 +413,20 @@ struct dentry *tracefs_create_file(const char 
>> *name, umode_t mode,
>>       if (unlikely(!inode))
>>           return failed_creating(dentry);
>>   +    proxy_fops = kzalloc(sizeof(struct file_operations), GFP_KERNEL);
>> +    if (unlikely(!proxy_fops)) {
>> +        iput(inode);
>> +        return failed_creating(dentry);
>> +    }
>> +
>> +    if (!fops)
>> +        fops = &tracefs_file_operations;
>> +
>> +    dentry->d_fsdata = (void *)fops;
>> +    memcpy(proxy_fops, fops, sizeof(*proxy_fops));
>> +    proxy_fops->open = default_open_file;
>>       inode->i_mode = mode;
>> -    inode->i_fop = fops ? fops : &tracefs_file_operations;
>> +    inode->i_fop = proxy_fops;
>>       inode->i_private = data;
>>       d_instantiate(dentry, inode);
>>       fsnotify_create(dentry->d_parent->d_inode, dentry);
>> diff --git a/include/linux/security.h b/include/linux/security.h
>> index d92323b44a3f..807dc0d24982 100644
>> --- a/include/linux/security.h
>> +++ b/include/linux/security.h
>> @@ -121,6 +121,7 @@ enum lockdown_reason {
>>       LOCKDOWN_KPROBES,
>>       LOCKDOWN_BPF_READ,
>>       LOCKDOWN_PERF,
>> +    LOCKDOWN_TRACEFS,
>>       LOCKDOWN_CONFIDENTIALITY_MAX,
>>   };
>>   diff --git a/security/lockdown/lockdown.c 
>> b/security/lockdown/lockdown.c
>> index 88064ce1c844..173191562047 100644
>> --- a/security/lockdown/lockdown.c
>> +++ b/security/lockdown/lockdown.c
>> @@ -36,6 +36,7 @@ static char 
>> *lockdown_reasons[LOCKDOWN_CONFIDENTIALITY_MAX+1] = {
>>       [LOCKDOWN_KPROBES] = "use of kprobes",
>>       [LOCKDOWN_BPF_READ] = "use of bpf to read kernel RAM",
>>       [LOCKDOWN_PERF] = "unsafe use of perf",
>> +    [LOCKDOWN_TRACEFS] = "use of tracefs",
>>       [LOCKDOWN_CONFIDENTIALITY_MAX] = "confidentiality",
>>   };
>
> Best regards

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

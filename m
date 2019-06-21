From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH V33 01/30] security: Support early LSMs
Date: Thu, 20 Jun 2019 20:21:59 -0700
Message-ID: <201906202010.49D16E03@keescook>
References: <20190621011941.186255-1-matthewgarrett@google.com>
 <20190621011941.186255-2-matthewgarrett@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190621011941.186255-2-matthewgarrett@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <matthewgarrett@google.com>
Cc: jmorris@namei.org, linux-security@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Matthew Garrett <mjg59@google.com>
List-Id: linux-api@vger.kernel.org

On Thu, Jun 20, 2019 at 06:19:12PM -0700, Matthew Garrett wrote:
> The lockdown module is intended to allow for kernels to be locked down
> early in boot - sufficiently early that we don't have the ability to
> kmalloc() yet. Add support for early initialisation of some LSMs, and
> then add them to the list of names when we do full initialisation later.

So, if I'm reading correctly, these "early LSMs":

- start up before even boot parameter parsing has happened
- have their position in the LSM ordering ignored
- are initialized in boot order
- cannot use kmalloc, as well as probably lots of other things

> 
> Signed-off-by: Matthew Garrett <mjg59@google.com>
> ---
>  include/asm-generic/vmlinux.lds.h |  8 +++++-
>  include/linux/lsm_hooks.h         |  6 ++++
>  include/linux/security.h          |  1 +
>  init/main.c                       |  1 +
>  security/security.c               | 48 +++++++++++++++++++++++++------
>  5 files changed, 54 insertions(+), 10 deletions(-)
> 
> diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
> index f8f6f04c4453..e1963352fdb6 100644
> --- a/include/asm-generic/vmlinux.lds.h
> +++ b/include/asm-generic/vmlinux.lds.h
> @@ -208,8 +208,13 @@
>  			__start_lsm_info = .;				\
>  			KEEP(*(.lsm_info.init))				\
>  			__end_lsm_info = .;
> +#define EARLY_LSM_TABLE()	. = ALIGN(8);				\
> +			__start_early_lsm_info = .;			\
> +			KEEP(*(.early_lsm_info.init))			\
> +			__end_early_lsm_info = .;
>  #else
>  #define LSM_TABLE()
> +#define EARLY_LSM_TABLE()
>  #endif
>  
>  #define ___OF_TABLE(cfg, name)	_OF_TABLE_##cfg(name)
> @@ -610,7 +615,8 @@
>  	ACPI_PROBE_TABLE(irqchip)					\
>  	ACPI_PROBE_TABLE(timer)						\
>  	EARLYCON_TABLE()						\
> -	LSM_TABLE()
> +	LSM_TABLE()							\
> +	EARLY_LSM_TABLE()
>  
>  #define INIT_TEXT							\
>  	*(.init.text .init.text.*)					\
> diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
> index a240a3fc5fc4..66fd1eac7a32 100644
> --- a/include/linux/lsm_hooks.h
> +++ b/include/linux/lsm_hooks.h
> @@ -2085,12 +2085,18 @@ struct lsm_info {
>  };
>  
>  extern struct lsm_info __start_lsm_info[], __end_lsm_info[];
> +extern struct lsm_info __start_early_lsm_info[], __end_early_lsm_info[];
>  
>  #define DEFINE_LSM(lsm)							\
>  	static struct lsm_info __lsm_##lsm				\
>  		__used __section(.lsm_info.init)			\
>  		__aligned(sizeof(unsigned long))
>  
> +#define DEFINE_EARLY_LSM(lsm)						\
> +	static struct lsm_info __early_lsm_##lsm			\
> +		__used __section(.early_lsm_info.init)			\
> +		__aligned(sizeof(unsigned long))
> +
>  #ifdef CONFIG_SECURITY_SELINUX_DISABLE
>  /*
>   * Assuring the safety of deleting a security module is up to
> diff --git a/include/linux/security.h b/include/linux/security.h
> index 49f2685324b0..1bb6fb2f1523 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -194,6 +194,7 @@ int unregister_lsm_notifier(struct notifier_block *nb);
>  
>  /* prototypes */
>  extern int security_init(void);
> +extern int early_security_init(void);
>  
>  /* Security operations */
>  int security_binder_set_context_mgr(struct task_struct *mgr);
> diff --git a/init/main.c b/init/main.c
> index 598e278b46f7..f3faeb89c75f 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -563,6 +563,7 @@ asmlinkage __visible void __init start_kernel(void)
>  	boot_cpu_init();
>  	page_address_init();
>  	pr_notice("%s", linux_banner);
> +	early_security_init();
>  	setup_arch(&command_line);
>  	/*
>  	 * Set up the the initial canary and entropy after arch
> diff --git a/security/security.c b/security/security.c
> index 23cbb1a295a3..2a6672c9e72f 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -37,6 +37,7 @@
>  
>  /* How many LSMs were built into the kernel? */
>  #define LSM_COUNT (__end_lsm_info - __start_lsm_info)
> +#define EARLY_LSM_COUNT (__end_early_lsm_info - __start_early_lsm_info)
>  
>  struct security_hook_heads security_hook_heads __lsm_ro_after_init;
>  static ATOMIC_NOTIFIER_HEAD(lsm_notifier_chain);
> @@ -281,6 +282,8 @@ static void __init ordered_lsm_parse(const char *order, const char *origin)
>  static void __init lsm_early_cred(struct cred *cred);
>  static void __init lsm_early_task(struct task_struct *task);
>  
> +static int lsm_append(const char *new, char **result);
> +
>  static void __init ordered_lsm_init(void)
>  {
>  	struct lsm_info **lsm;
> @@ -327,15 +330,11 @@ static void __init ordered_lsm_init(void)
>  	kfree(ordered_lsms);
>  }
>  
> -/**
> - * security_init - initializes the security framework
> - *
> - * This should be called early in the kernel initialization sequence.
> - */
> -int __init security_init(void)
> +int __init early_security_init(void)
>  {
>  	int i;
>  	struct hlist_head *list = (struct hlist_head *) &security_hook_heads;
> +	struct lsm_info *lsm;
>  
>  	pr_info("Security Framework initializing\n");

I'd rather this was kept in security_init() since it's the string to
search for when debugging normal LSM initialization.

>  
> @@ -343,6 +342,30 @@ int __init security_init(void)
>  	     i++)
>  		INIT_HLIST_HEAD(&list[i]);
>  
> +	for (lsm = __start_early_lsm_info; lsm < __end_early_lsm_info; lsm++) {
> +		if (!lsm->enabled)
> +			lsm->enabled = &lsm_enabled_true;
> +		initialize_lsm(lsm);
> +	}

This should call prepare_lsm() before initialize_lsm(). While not needed
for this specific LSM, it would be nice to at least do the blog size
calculations and keep everything the same as other LSMs.

> +
> +	return 0;
> +}
> +
> +/**
> + * security_init - initializes the security framework
> + *
> + * This should be called early in the kernel initialization sequence.
> + */
> +int __init security_init(void)
> +{
> +	struct lsm_info *lsm;
> +
> +	/* Append the names of the early LSM modules now */

I would clarify this comment more: "... that kmalloc() is available."

> +	for (lsm = __start_early_lsm_info; lsm < __end_early_lsm_info; lsm++) {
> +		if (lsm->enabled)
> +			lsm_append(lsm->name, &lsm_names);
> +	}
> +
>  	/* Load LSMs in specified order. */
>  	ordered_lsm_init();
>  
> @@ -388,7 +411,7 @@ static bool match_last_lsm(const char *list, const char *lsm)
>  	return !strcmp(last, lsm);
>  }
>  
> -static int lsm_append(char *new, char **result)
> +static int lsm_append(const char *new, char **result)
>  {
>  	char *cp;
>  
> @@ -426,8 +449,15 @@ void __init security_add_hooks(struct security_hook_list *hooks, int count,
>  		hooks[i].lsm = lsm;
>  		hlist_add_tail_rcu(&hooks[i].list, hooks[i].head);
>  	}
> -	if (lsm_append(lsm, &lsm_names) < 0)
> -		panic("%s - Cannot get early memory.\n", __func__);
> +
> +	/*
> +	 * Don't try to append during early_security_init(), we'll come back
> +	 * and fix this up afterwards.
> +	 */
> +	if (slab_is_available()) {
> +		if (lsm_append(lsm, &lsm_names) < 0)
> +			panic("%s - Cannot get early memory.\n", __func__);
> +	}
>  }
>  
>  int call_lsm_notifier(enum lsm_event event, void *data)
> -- 
> 2.22.0.410.gd8fdbe21b5-goog
> 

-- 
Kees Cook

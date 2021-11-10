import asyncio
import os

import dotenv
import requests_async as requests

dotenv.load_dotenv()

job_secret = os.getenv("JOB_SECRET_KEY")
api_prefix = os.getenv("NDD_API_PREFIX")


async def update_job_run_date(job_id: str):
    await requests.put(
        api_prefix + f"jobs?job_id={job_id}", headers={"secret": job_secret}
    )
    return


async def fetch_expired_ads():
    try:
        expired_ads = await requests.get(
            api_prefix + "expired_ads", headers={"secret": job_secret}
        )

        if len(expired_ads.json()) == 0:
            await update_job_run_date(os.getenv("EXPIRED_ADS_JOB_ID"))

        if expired_ads.status_code == 403:
            return

        if expired_ads.json():
            return expired_ads.json()

    except Exception:
        raise (Exception)


async def delete_expired_ads():
    try:
        ad_list = await fetch_expired_ads()

        payload = {"ad_list": ad_list}

        if ad_list:
            delete_status = await requests.delete(
                api_prefix + "delete_ads",
                json=payload,
                headers={"secret": job_secret},
            )

        if delete_status.json() == "All expired ads deleted":
            await update_job_run_date(os.getenv("EXPIRED_ADS_JOB_ID"))

    except Exception:
        raise (Exception)


if __name__ == "__main__":
    asyncio.run(delete_expired_ads())

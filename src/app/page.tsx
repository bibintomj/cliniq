import { Button } from "@/components/ui/button";
import { Link } from "lucide-react";
import LoginPage from "./Auth/login/page";

export default function Home() {
  return (
    // <div className="grid grid-rows-[20px_1fr_20px] items-center justify-items-center min-h-screen p-8 pb-20 gap-16 sm:p-20 font-[family-name:var(--font-geist-sans)]">
    //   <Button className="bg-primary text-white">
    //     <a href="/clinic/dashboard">Dashboard</a>
    //   </Button>
    // </div>
    <div>
      <LoginPage />
    </div>
  );
}
